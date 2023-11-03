module AntifraudServices
  class TransactionRateLimitService
    RATE_LIMIT = 60

    attr_reader :user_id, :transaction_amount, :redis

    def initialize(user_id, transaction_amount)
      @user_id = user_id
      @transaction_amount = transaction_amount
      @redis = Redis.new
    end

    def call
      exceeded_transaction_limit?
    end

    private

    def exceeded_transaction_limit?
      key = "user_transactions:#{@user_id}:#{@transaction_amount}"

      if redis.exists(key)
        return true
      else
        redis.setex(key, RATE_LIMIT, '1')
        return false
      end
    end
  end
end
