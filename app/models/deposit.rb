class Deposit < Transaction
  belongs_to :source_wallet, class_name: 'Wallet', foreign_key: 'source_wallet_id'
  belongs_to :target_wallet, class_name: 'Wallet', foreign_key: 'target_wallet_id', optional: true
  belongs_to :wallet

  def process_transaction
    source_wallet.increment!(:balance, amount)
  end

  def as_json(options = {})
    super(options.merge(only: [:amount, :created_at, :updated_at, :type]))
  end
end
