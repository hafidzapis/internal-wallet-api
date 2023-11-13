class TransactionLog < ApplicationRecord
  belongs_to :related_transaction, polymorphic: true, class_name: 'Transaction'

  validates :type, presence: true
  validates :details, presence: true
end