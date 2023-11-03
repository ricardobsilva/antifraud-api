require 'rails_helper'

RSpec.describe TransactionService, type: :service do
  let(:subject) { TransactionService.new(params).call }
  let(:user) { create(:user) }
  let(:merchant) { create(:merchant) }
  let(:device) {create(:device) }

  describe '#call' do
    context 'when approve the transaction' do
      let(:params) do
        {
          "transaction_id": 2342357,
          "merchant_id": merchant.id,
          "user_id": user.id,
          "card_number": "434505******9116",
          "transaction_date": "2019-11-31T23:16:32.812632",
          "transaction_amount": 373,
          "device_id": device.id
        }
      end

      it do
        expect(subject[:transaction_id]).to eq(params[:transaction_id])
        expect(subject[:recommendation]).to eq("approved")
      end
    end

    context 'when the user has transactions with fraud chargebacks' do
      let(:transaction_with_cbk) do 
        create(:transaction, user: user, has_cbk: true, merchant: merchant, device: device)
      end

      let(:params) do
        {
          "transaction_id": 2342357,
          "merchant_id": merchant.id,
          "user_id": user.id,
          "card_number": "434505******9116",
          "transaction_date": "2019-11-31T23:16:32.812632",
          "transaction_amount": 373,
          "device_id": device.id
        }
      end

      before { transaction_with_cbk }

      it 'must deny the transaction' do
        expect(subject[:transaction_id]).to eq(params[:transaction_id])
        expect(subject[:recommendation]).to eq("deny")
      end
    end

    context 'when the transaction amount exceeds the limit or is after the cutoff time' do
      let(:params) do
        {
          "transaction_id": 2342357,
          "merchant_id": merchant.id,
          "user_id": user.id,
          "card_number": "434505******9116",
          "transaction_date": DateTime.current,
          "transaction_amount": 2_100,
          "device_id": device.id
        }
      end

      before do 
        travel_to(Time.current.beginning_of_day + 22.hours)
      end

      it 'must deny the transaction' do
        expect(subject[:transaction_id]).to eq(params[:transaction_id])
        expect(subject[:recommendation]).to eq("deny")
      end
    end
  end 
end