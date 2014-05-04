class CreateRobokassaTransactions < ActiveRecord::Migration
  def change
    create_table :spree_robokassa_transactions do |t|
      t.timestamps
    end
  end
end
