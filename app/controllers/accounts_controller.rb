class AccountsController < ApplicationController
	before_action :correct_user, only: [:edit, :destroy]

	def new
		@account = Account.new
	end

	def create
		@account = current_user.accounts.build(balance: 0.0, name: params[:account][:name])
		if @account.save
			flash[:success] = "New account created"
			redirect_to user_path(current_user)
		else
			flash[:error] = "Could not create account"
			redirect_to user_path(current_user)
		end
	end

	def edit
		@user = current_user
		@account = current_user.accounts.find(params[:id])
	end

	def transfer
	end

	

	def destroy
		if @account.balance == 0.0
			@account.destroy
			redirect_to user_path(current_user)
		elsif @account.balance > 0.0
			flash[:error] = "You must pull out the remaining balance first"
			redirect_to user_path(current_user)
		else
			flash[:error] = "Could not delete account"
		end
	end

	private
	def account_params
		params.require(:account).permit(:name, :balance)
	end

	def correct_user
		@account = current_user.accounts.find_by(id: params[:id])
		redirect_to root_url if @account.nil?
	end
end
