
class Api::V1::TransactionController < ApplicationController
  before_action :authenticate_request
  before_action :set_source_wallet, only: [:create_deposit, :create_withdrawal, :create_transfer]
  def create_deposit
    source_wallet = Wallet.find(params[:source_wallet_id])
    amount = params[:amount].to_f
    data = TransactionService.process_deposit(source_wallet, amount)

    response_json(data, 200)
  end

  def create_withdrawal
    source_wallet = Wallet.find(params[:source_wallet_id])
    amount = params[:amount].to_f
    withdrawal = TransactionService.process_withdrawal(source_wallet, source_wallet, amount)

    response_json(withdrawal, 200)
  end

  def create_transfer
    source_wallet = Wallet.find(params[:source_wallet_id])
    target_wallet = Wallet.find(params[:target_wallet_id])
    amount = params[:amount].to_f

    response = TransactionService.transfer_funds(source_wallet, target_wallet, amount)
    response_json(response, 200)
  end

  private

  def set_source_wallet
    @source_wallet = Wallet.find(params[:source_wallet_id])
    @entity_id = @current_user.id
    # Ensure that the source_wallet belongs to the current_user
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @source_wallet.entity_id == @entity_id
  end

end
