class CountriesController < ApplicationController
  before_filter :login_required, :except => [:show, :visited]
  before_filter :find_country,   :only => [:show, :update, :buy_currency]
  before_filter :get_data,       :only => [:index, :show]

  def index
    @countries = Country.all
  end

  def visited
    @countries = Country.visited
  end
  
  def show
    @country_currency = CountryCurrency.new
  end

  def buy_currency
    @country.country_currencies.create!(params[:country_currency]) unless @country.country_currencies.exists?(:currency_code => params[:country_currency][:currency_code])
    flash[:notice] = 'Saved'
    redirect_to country_path(@country.code)
  end

  def update
    @country.update_attributes(params[:country])
    flash[:notice] = 'Saved'
    
    redirect_to country_path(@country.code)
  end

  private

  def find_country
    @country = Country.find_by_code(params[:id])
  end
end
