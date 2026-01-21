module Wallets
  class Ledger
    Result = Struct.new(:success?, :error)

    def initialize(wallet:)
      @wallet = wallet
    end

    def credit(amount:, operation_id:)
      return Result.new(false, :invalid_amount) if invalid_amount?(amount)
      return Result.new(false, :duplicate_operation) if duplicate_operation?(operation_id)

      #Ledger Entry must use the transaction block so that the whole block of code will rollback if the credit operation failed
      ActiveRecord::Base.transaction do
        @wallet.lock!

        LedgerEntry.create!(
          wallet_id: @wallet.id,
          amount: amount,
          entry_type: "credit",
          operation_id: operation_id,
          note: "Credit"
        )
      end

      Result.new(true, nil)
    rescue ActiveRecord::RecordNotUnique
      Result.new(false, :duplicate_operation)
    end

    def debit(amount:, operation_id:)
      return Result.new(false, :invalid_amount) if invalid_amount?(amount)
      return Result.new(false, :duplicate_operation) if duplicate_operation?(operation_id)

      ActiveRecord::Base.transaction do
        @wallet.lock!

        return Result.new(false, :insufficient_balance) if insufficient_balance?(amount)

        LedgerEntry.create!(
          wallet_id: @wallet.id,
          amount: -amount,
          entry_type: "debit",
          operation_id: operation_id,
          note: "Debit"
        )
      end

      Result.new(true, nil)
    rescue ActiveRecord::RecordNotUnique
      Result.new(false, :duplicate_operation)
    end

    private

    def invalid_amount?(amount)
      amount.nil? || amount <= 0
    end

    def duplicate_operation?(operation_id)
      LedgerEntry.exists?(operation_id: operation_id)
    end

    def insufficient_balance?(amount)
      @wallet.balance < amount
    end
  end
end
