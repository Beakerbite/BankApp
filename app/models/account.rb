class Account < ActiveRecord::Base
	belongs_to :user
	validates :name, presence: true, length: { maximum: 50 }
	validates :user_id, presence: true
	validates :balance, presence: true
	default_scope -> { order('name DESC') }
end
