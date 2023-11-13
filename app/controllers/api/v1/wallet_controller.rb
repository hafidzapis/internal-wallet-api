class Api::V1::WalletController < ApplicationController
  before_action :authenticate_request
  before_action :set_entity_id, only: [:get_balance, :create_wallet]
  before_action :find_entity, only: [:create_wallet]

  def get_balance
    @wallet = Wallet.find_by(entity_id: @entity_id)
    @balance = TransactionService.view_balance(@wallet)
    @transaction_history = TransactionService.transaction_history(@wallet)

    render json: {
      wallet: @wallet.as_json,
      balance: @balance,
      transaction_history: @transaction_history.as_json
    }
  end

  def create_wallet
    # Check if the entity already has a wallet
    if @current_user.wallet.present?
      raise Rest::Errors::WalletError.new(422, {}, "#{@current_user.type} with #{@entity_id} already has a wallet")
    else
      # Create a wallet for the entity with zero balance
      wallet = Wallet.create!(entity: @current_user, balance: 0)
      render json: { message: 'Wallet created successfully', wallet_id: wallet.id }
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end


  private

  def find_entity
    @entity = Entity.find(@entity_id)
  end

  private

  def set_entity_id
    @entity_id = @current_user.id
  end

end