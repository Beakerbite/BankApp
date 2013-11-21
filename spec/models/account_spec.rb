require 'spec_helper'

describe Account do

	let(:user) { FactoryGirl.create(:user) }
	
	before { @account = user.accounts.build(balance: 100.0, name: "#{user.name}'s First Account") }

	subject { @account }

	it { should respond_to(:balance) }
	it { should respond_to(:user_id) }

	it { should be_valid }
end
