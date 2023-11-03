FactoryBot.define do
  factory :transaction do
    card_number { "434505******9116" }
    has_cbk { false }
    transaction_amount { 734.87 }
    transaction_date { "2019-11-31T23:16:32.812632" }
    user { nil }
    merchant { nil }
    device { nil }
  end
end