namespace :import_csv do
  task :import_data => :environment do
    require 'csv'

    csv_file = Rails.root.join('app', 'docs', 'transactional-sample.csv')

    transactions = []
    CSV.foreach(csv_file, headers: true) do |row|
      merchant = Merchant.find_or_create_by(id: row['merchant_id'])
      user = User.find_or_create_by(id: row['user_id'])
      device = Device.find_or_create_by(id: row['device_id'])
      
      transaction = Transaction.new(
        id: row['transaction_id'],
        merchant: merchant,
        user: user,
        card_number: row['card_number'],
        transaction_date: row['transaction_date'],
        transaction_amount: row['transaction_amount'],
        device: device,
        has_cbk: row['has_cbk']
      )

      transactions << transaction
    end

    Transaction.import transactions, on_duplicate_key_update: [:id]
  end
end
