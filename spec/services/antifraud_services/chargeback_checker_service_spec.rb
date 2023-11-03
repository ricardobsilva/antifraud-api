require 'rails_helper'

RSpec.describe AntifraudServices::ChargebackCheckerService, type: :service do
  let(:subject) { described_class.new(user.id).call }

  describe '#call' do
    let(:user) { create(:user) }

    context "when the user has chargeback fraud" do
      let(:transaction_with_cbk) do 
        merchant = create(:merchant)
        device = create(:device)
        create(:transaction, user: user, has_cbk: true, merchant: merchant, device: device)
      end

      before { transaction_with_cbk }

      it do
        expect(subject).to be_truthy
      end
    end

    context "when the user doesn't have chargeback fraud" do
      let(:transaction_without_cbk) do 
        merchant = create(:merchant)
        device = create(:device)
        create(:transaction, user: user, has_cbk: false, merchant: merchant, device: device)
      end

      before { transaction_without_cbk }

      it do
        expect(subject).to be_falsey
      end
    end
  end
end