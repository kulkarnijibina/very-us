class CoinPackage < ApplicationRecord
	 validates :title, :amount, :coins, presence: true
end
