class Wallet < ApplicationRecord
  has_many :ledger_entries

  def balance
    ledger_entries.sum(:amount)
  end
end
