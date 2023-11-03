class Transaction < ApplicationRecord
  belongs_to :merchant
  belongs_to :user
  belongs_to :device
end
