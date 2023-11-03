module AntifraudServices
  class TransactionAmountValidatorService
    MAX_TRANSACTION_AMOUNT = 2_000
    CUTOFF_HOUR = 22
  
    def initialize(amount)
      @amount = amount.to_d
    end
  
    def call
      return false if exceeded_maximum_amount? && exceeded_cutoff_hour?
  
      true
    end
  
    private
  
    def exceeded_maximum_amount?
      @amount > MAX_TRANSACTION_AMOUNT
    end
  
    def exceeded_cutoff_hour?
      DateTime.current.hour >= CUTOFF_HOUR
    end
  end
end