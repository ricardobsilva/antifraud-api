class TransactionService
  attr_reader :params, :device, :merchant, :user

  def initialize(params)
    @params = params
    @device = Device.find(params[:device_id])
    @merchant = Merchant.find(params[:merchant_id])
    @user = User.find(params[:user_id])
  end

  def call
    if invalid_transaction?
      result = Transaction.statuses[:deny]
      transaction_id = params[:transaction_id]
    else
      transaction_id = persist_transaction.id
      result = Transaction.statuses[:approved]
    end

    recomendation_data(transaction_id, result)
  end

  private

  def recomendation_data(transaction_id, result)
    {
      "transaction_id": transaction_id,
      "recommendation": result
    }
  end

  def invalid_transaction?
    user_has_transactions_with_fraud_chargebacks? || !valid_transaction_amount? || reached_same_transaction_limit_within_timeframe?
  end

  def user_has_transactions_with_fraud_chargebacks?
    AntifraudServices::ChargebackCheckerService.new(user.id).call
  end
  
  def valid_transaction_amount?
    AntifraudServices::TransactionAmountValidatorService.new(params[:transaction_amount]).call
  end

  def reached_same_transaction_limit_within_timeframe?
    AntifraudServices::TransactionRateLimitService.new(user.id, params[:transaction_id]).call
  end

  def persist_transaction
    Transaction.create!(
      id: params[:transaction_id],
      device: device,
      merchant: merchant,
      user: user,
      card_number: params[:card_number],
      transaction_amount: params[:card_number],
      transaction_date: params[:transaction_date]
    )
  end
end
