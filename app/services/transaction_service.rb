class TransactionService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    if invalid_transaction?
      result = Transaction.statuses[:deny]
    else
      result = Transaction.statuses[:approved]
    end

    recomendation_data(params[:transaction_id], result)
  end

  private

  def recomendation_data(transaction_id, result)
    {
      "transaction_id": transaction_id,
      "recommendation": result
    }
  end

  def invalid_transaction?
    user_has_transactions_with_fraud_chargebacks? || !valid_transaction_amount?
  end

  def user_has_transactions_with_fraud_chargebacks?
    AntifraudServices::ChargebackCheckerService.new(params[:user_id]).call
  end
  
  def valid_transaction_amount?
    AntifraudServices::TransactionAmountValidatorService.new(params[:transaction_amount]).call
  end
end