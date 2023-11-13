class TransactionService

  # Process a deposit transaction, adding the amount to a single wallet's balance.
  def self.process_deposit(source_wallet, amount)
    ActiveRecord::Base.transaction do
      validate_transaction_frequency(source_wallet)
      validate_amount_positive(amount)
      deposit = Deposit.create!(source_wallet: source_wallet, target_wallet: source_wallet, amount: amount, wallet: source_wallet)
      increment_wallet_balance(source_wallet, amount.abs)
      deposit.as_json
    end
  end

  # Process a withdrawal transaction, subtracting the amount from a single wallet's balance.
  def self.process_withdrawal(source_wallet, target_wallet, amount)
    ActiveRecord::Base.transaction do
      validate_transaction_frequency(source_wallet)
      validate_amount_positive(amount)
      validate_transaction_limit(amount)
      validate_sufficient_balance(source_wallet, amount)
      withdrawal = Withdrawal.create!(source_wallet: source_wallet, target_wallet: target_wallet, amount: amount, wallet: source_wallet)
      decrement_wallet_balance(source_wallet, amount)
      withdrawal.as_json
    end
  end

  # Transfer funds between two wallets, subtracting the amount from the source wallet
  # and adding it to the target wallet.
  def self.transfer_funds(source_wallet, target_wallet, amount)
    ActiveRecord::Base.transaction do
      validate_transaction_frequency(source_wallet)
      validate_amount_positive(amount)
      validate_transaction_limit(amount)
      validate_sufficient_balance(source_wallet, amount)
      withdrawal = Withdrawal.create!(source_wallet: source_wallet, target_wallet: source_wallet, amount: amount, wallet: source_wallet)
      deposit = Deposit.create!(source_wallet: source_wallet, target_wallet: target_wallet, amount: amount, wallet: target_wallet)
      decrement_wallet_balance(source_wallet, amount)
      increment_wallet_balance(target_wallet, amount)
      { withdrawal: withdrawal.as_json, deposit: deposit.as_json }
    end
  end

  def self.view_balance(wallet)
    wallet.balance
  end

  def self.transaction_history(wallet)
    Transaction.where("source_wallet_id = ? OR target_wallet_id = ?", wallet.id, wallet.id)
               .order(created_at: :desc)
  end

  private

  def self.increment_wallet_balance(wallet, amount)
    wallet.increment!(:balance, amount)
  end

  def self.decrement_wallet_balance(wallet, amount)
    wallet.decrement!(:balance, amount)
  end

  def self.validate_amount_positive(amount)
    raise Rest::Errors::TransactionError.new(422, {}, 'Amount must be greater than zero') unless amount.positive?
  end

  def self.validate_sufficient_balance(wallet, amount)
    minimum_balance = ENV['MIN_BALANCE'].to_f
    if wallet.balance - amount < minimum_balance
      raise Rest::Errors::TransactionError.new(422, {}, 'Insufficient balance')
    end
  end

  def self.validate_transaction_limit(amount)
    raise Rest::Errors::TransactionError.new(422, {}, "Transaction amount exceeds maximum limit") if amount > ENV['MAX_TRANSACTION_LIMIT'].to_f
    raise Rest::Errors::TransactionError.new(422, {}, "Transaction amount below minimum limit") if amount < ENV['MIN_TRANSACTION_LIMIT'].to_f
  end

  def self.validate_transaction_frequency(wallet)
    last_transactions = Transaction.where(source_wallet: wallet)
                                   .where("created_at >= ?", Time.now - ENV['TRANSACTION_TIME_WINDOW'].to_i.minute)
    raise Rest::Errors::TransactionError.new(422, {}, "Transaction frequency exceeded limit") if last_transactions.count >= ENV['TRANSACTION_FREQUENCY_LIMIT'].to_i
  end

end