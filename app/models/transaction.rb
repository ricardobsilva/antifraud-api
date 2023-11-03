class Transaction < ApplicationRecord
  belongs_to :merchant
  belongs_to :user
  belongs_to :device

  enum status: { approved: "approved", deny: "deny" }
end
