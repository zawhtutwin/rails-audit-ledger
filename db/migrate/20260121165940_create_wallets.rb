class CreateWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :wallets do |t|
      t.string :owner_reference, null: false
      t.timestamps
    end

    add_index :wallets, :owner_reference, unique: true
  end
end
