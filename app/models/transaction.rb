class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', foreign_key: 'source_wallet_id'
  belongs_to :target_wallet, class_name: 'Wallet', foreign_key: 'target_wallet_id', optional: true

  validates :type, presence: true
  validates :amount, presence: true

  validates_presence_of :amount, :source_wallet_id, :target_wallet_id
  validates_numericality_of :amount, greater_than_or_equal_to: 0

  def deposit_transaction?
    type == 'Deposit'
  end

  def withdraw_transaction?
    type == 'Withdraw'
  end

  def process_transaction
    raise NotImplementedError, 'Subclasses must implement this method'
  end

  def as_json(options = {})
    super(options.merge({ methods: :type }))
  end

  def amount_does_not_exceed_limit
    if amount && amount > source_wallet.balance
      errors.add(:amount, "cannot exceed the balance in the source wallet")
    end
  end
end
