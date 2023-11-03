class TransactionsController < ApplicationController
  def create
    transaction = TransactionService.new(transaction_params).call

    if transaction[:recommendation] == "approved"
      render json: transaction, status: :created
    else
      render json: transaction, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.permit(
      :transaction_id,
      :merchant_id,
      :user_id,
      :card_number,
      :transaction_date,
      :transaction_amount,
      :device_id
    )
  end
end
