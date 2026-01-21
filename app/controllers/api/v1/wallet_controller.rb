class Api::V1::WalletController < ActionController::API
  # POST /api/v1/wallets
  def create
    wallet = Wallet.create!(wallet_params)

    render json: {
      wallet_id: wallet.id,
      balance: wallet.balance
    }, status: :created
  end

  # GET /api/v1/wallets/:id
  def show
    wallet = Wallet.find(params[:id])

    render json: {
      wallet_id: wallet.id,
      balance: wallet.balance
    }, status: :ok
  end

  private

  def wallet_params
    params.require(:wallet).permit(:owner_reference)
  end
end