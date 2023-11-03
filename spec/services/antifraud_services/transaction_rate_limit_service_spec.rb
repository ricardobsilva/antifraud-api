require 'rails_helper'

RSpec.describe AntifraudServices::TransactionRateLimitService, type: :service do
  let(:user_id) { 1 }
  let(:transaction_amount) { 100 }
  let(:service) { described_class.new(user_id, transaction_amount) }
  let(:redis) { Redis.new }

  describe '#call' do
    context 'when a transaction with the same value exists for the user within the same minute' do
      it 'returns false' do
        key = "user_transactions:#{user_id}:#{transaction_amount}"
        redis.setex(key, 60, '1')

        expect(service.call).to eq(true)
      end
    end

    context 'when no transaction with the same value exists for the user within the same minute' do
      it 'returns true' do
        key = "user_transactions:#{user_id}:#{transaction_amount}"
        redis.del(key)

        expect(service.call).to eq(false)
      end
    end
  end  
end
