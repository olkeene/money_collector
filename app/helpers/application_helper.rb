module ApplicationHelper
  def offers_for_country(countries, hash)
    visited = countries.find_all{|c| c.code == hash[:country_code] && c.visited? }.size
    "Visited: #{visited}, Remain: #{hash[:offer_count] - visited}"
  end
end
