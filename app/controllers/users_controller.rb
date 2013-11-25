class UsersController < ApplicationController
	before_action	:admin_user,		only: [:destroy, :create, :new, :index]
	before_action	:correct_user,		only: [:edit, :update, :show]


	def new
		@user = User.new
	end

	def show
		if (current_user.admin?)
			@user = User.find(params[:id].to_i)
			@accounts = @user.accounts.all
		else
			@user = current_user
			@accounts = @user.accounts.all
		end
	end

	def manage
		@user = User.find(params[:id].to_i)
		redirect_to user_path(@user)
	rescue
		flash[:error] = "Problem finding user"
		redirect_to root_url
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to root_url
		else
			render 'edit'
		end
	end

	def index
		@users = User.paginate(page: params[:page])
	end

	def create
		@user = User.new(user_params)
		if @user.save
			@account = @user.accounts.build(balance: 0.0, name: "Savings")
			if @account.save
				flash.now[:success] = "User created"
				redirect_to user_path(@user)
				return
			else
				flash.now[:error] = "User created but could not create default account"
				redirect_to user_path(@user)
			end
		else
			render 'new'
		end
	end

	def destroy
		fndUser = User.find(params[:id])
		unless fndUser == current_user
			fndUser.destroy
			flash[:success] = "User deleted"
			redirect_to index_path
		else
			flash[:error] = "Cannot delete self."
			redirect_to root_url
		end
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless (current_user?(@user) || current_user.admin?)
	rescue
		redirect_to(root_url)
	end

	def admin_user
		redirect_to(root_url) unless current_user.admin?
	end
end
