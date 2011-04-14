class CurrenciesController < ApplicationController
  before_filter :get_data
  
  def index
    @currencies = Service.process :get_currencies
    @countries  = Country.all

    if params[:show_remained]
      @data = @data.reject{|d| # coz array is frozed
        !!@countries.find{|c| c.code == d[:country_code] && c.visited? }
      }
    end
  end

  def show
    countries = @data.find_all{|d| d[:currency_code] == params[:id] }.collect{|d| {:country => d[:country], :country_code => d[:country_code]}}

    respond_to do |f|
      f.js do
        render :json => {:countries => countries}
      end
    end
  end
end
