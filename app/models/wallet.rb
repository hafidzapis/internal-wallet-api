class Wallet < ApplicationRecord
  belongs_to :entity, polymorphic: true

  has_many :deposit_transactions, -> { where(type: 'Deposit') }, class_name: 'Transaction'
  has_many :withdrawal_transactions, -> { where(type: 'Withdrawal') }, class_name: 'Transaction'

  def balance
    deposit_amount = deposit_transactions.sum(:amount)
    withdrawal_amount = withdrawal_transactions.sum(:amount)
    deposit_amount - withdrawal_amount
  end
end
