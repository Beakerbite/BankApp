class AccountsController < ApplicationController
	require 'bigdecimal'

	before_action :correct_user, only: [:edit, :destroy]
	before_action :admin_user, only: [:new, :create]

	def new
		@account = Account.new
		@user = User.find_by(id: params[:format])
	end

	def create
		@user = User.find_by(id: params[:user])
		@account = @user.accounts.build(balance: 0.0, name: account_params[:name])
		if @account.save
			flash[:success] = "New account created."
			redirect_to user_path(@user)
		else
			flash[:error] = "Could not create account."
			redirect_to user_path(@user)
		end
	end

	def edit
		@user = current_user
		@account = current_user.accounts.find(params[:id])
	rescue
		flash[:error] = "There was a problem. Please contact an administator."
		redirect_to root_url
	end

	def transfer
		@account_from = current_user.accounts.find(params[:from_account].to_i)
		@account_to = current_user.accounts.find(params[:select_account][:to_account].to_i)
		amount = BigDecimal(params[:transfer_amount]).truncate(2)
		if amount <= 0.0
			flash[:error] = "Please enter a valid amount."
			redirect_to user_path(current_user)
			return
		end
		if amount > @account_from.balance
			flash[:error] = "Not enough money for request."
			redirect_to user_path(current_user)
		else
			@account_to.balance += amount
			@account_from.balance -= amount
			if @account_to.save && @account_from.save
				flash[:success] = "Transfer complete."
				redirect_to user_path(current_user)
			else
				flash[:error] = "There was a problem with the transfer. Please contact an administator."
				redirect_to root_url
			end
		end
	rescue
		flash[:error] = "There was a problem. Please contact an administator."
		redirect_to root_url
	end

	def deposit
		@account = current_user.accounts.find(params[:from_account].to_i)
		amount = BigDecimal(params[:amount]).truncate(2)
		if amount <= 0.0
			flash[:error] = "Please enter a valid amount."
			redirect_to user_path(current_user)
		else
			@account.balance += amount
			if @account.save
				flash[:success] = "Deposit complete."
				redirect_to user_path(current_user)
			else
				flash[:error] = "There was a problem with the deposit. Please contact an administator."
				redirect_to root_url
			end
		end
	rescue
		flash[:error] = "There was a problem. Please contact an administator."
		redirect_to root_url
	end

	def withdraw
		@account = current_user.accounts.find(params[:from_account].to_i)
		amount = BigDecimal(params[:amount]).truncate(2)
		if amount <= 0.0
			flash[:error] = "Please enter a valid amount."
			redirect_to user_path(current_user)
		elsif amount > @account.balance
			flash[:error] = "Not enough money for requested withdrawal"
			redirect_to user_path(current_user)
		else
			@account.balance -= amount
			if @account.save
				flash[:success] = "Withdrawal complete."
				redirect_to user_path(current_user)
			else
				flash[:error] = "There was a problem with the withdrawal. Please contact an administator."
				redirect_to root_url
			end
		end
	rescue
		flash[:error] = "There was a problem. Please contact an administator."
		redirect_to root_url
	end

	def destroy
		@account = Account.find(params[:id])
		@user = User.find_by(id: @account.user_id)
		if @account.balance == 0.0
			@account.destroy
			redirect_to user_path(@user)
		elsif @account.balance > 0.0
			flash[:error] = "You must pull out the remaining balance first."
			redirect_to user_path(@user)
		else
			flash[:error] = "Could not delete account."
		end
	end

	private
	def account_params
		params.require(:account).permit(:name)
	end

	def correct_user
		@account = current_user.accounts.find_by(id: params[:id])
		if current_user.admin?
			return
		elsif @account.nil?
			redirect_to root_url
		end
	end

	def admin_user
		redirect_to root_url unless current_user.admin?
	end
end
