require 'rails_helper'

RSpec.describe TransactionsController, type: :request do
  let(:user) { create(:user) }
  let(:merchant) { create(:merchant) }
  let(:device) {create(:device) }
  
  describe "GET /create" do
    context "when transaction is approved" do
      let(:params) do
        {
          "transaction_id": 2342390,
          "merchant_id": merchant.id,
          "user_id": user.id,
          "card_number": "434505******9116",
          "transaction_date": "2019-11-31T23:16:32.812632",
          "transaction_amount": 373,
          "device_id": device.id
        }
      end

      it "must create a new transaction" do
        
        get "/transactions/create", params: params
        
        expect(response).to have_http_status(:success)
      end
    end

    context "when transaction is deny" do
      let(:transaction_with_cbk) do 
        create(:transaction, user: user, has_cbk: true, merchant: merchant, device: device)
      end

      let(:params) do
        {
          "transaction_id": 2342360,
          "merchant_id": merchant.id,
          "user_id": user.id,
          "card_number": "434505******9116",
          "transaction_date": "2019-11-31T23:16:32.812632",
          "transaction_amount": 373,
          "device_id": device.id
        }
      end
      
      before { transaction_with_cbk }

      it "must create a new transaction" do
        
        get "/transactions/create", params: params
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
