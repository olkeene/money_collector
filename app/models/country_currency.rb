class CountryCurrency < ActiveRecord::Base
  belongs_to :country, :counter_cache => 'visited_count'

  validate :country_id, :currency_code, :presence => true
end
