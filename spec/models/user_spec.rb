require 'spec_helper'

describe User do
	
	before { @user = FactoryGirl.create(:user) }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:email) }
	it { should respond_to(:admin) }
	it { should respond_to(:accounts) }

	it { should be_valid }
	it { should_not be_admin }
end
