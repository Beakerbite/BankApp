class ChangeBalanceFromFloatToDecimal < ActiveRecord::Migration
  def change
  	add_column :accounts, :new_balance, :decimal, :precision => 8, :scale => 2

  	Account.reset_column_information # make the new column available to model methods
	Account.all.each do |acct|
  		acct.new_balance = acct.balance
  		acct.save
	end

	remove_column :accounts, :balance
	rename_column :accounts, :new_balance, :balance
  end
end
