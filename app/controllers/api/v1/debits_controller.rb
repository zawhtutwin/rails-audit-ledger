class Api::V1::DebitsController < ActionController::API
      #POST /api/v1/wallets/:wallet_id/debit
      def create
        wallet = Wallet.find(params[:wallet_id])

        result = Wallets::Ledger.new(wallet: wallet).debit(
          amount: params.require(:amount).to_d,
          operation_id: params.require(:operation_id)
        )
        render_result(result, wallet)
      end

      private

      def render_result(result, wallet)
        if result.success?
          render json: { status: "ok", balance: wallet.balance }, status: :ok
        else
          render json: { status: "error", reason: result.error }, status: :unprocessable_entity
        end
      end
end
