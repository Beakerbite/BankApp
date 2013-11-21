class AddUserIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :user_id, :string
  end
end
