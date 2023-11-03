module AntifraudServices
  class ChargebackCheckerService
    attr_reader :user

    def initialize(user_id)
      @user = User.find(user_id)
    end

    def call
      has_chargeback?
    end

    private

    def has_chargeback?
      user.transactions.where(has_cbk: true).any?
    end
  end
end