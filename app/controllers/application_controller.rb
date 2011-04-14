class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery

  protected

  def get_data
    @data = Service.data
  end
end
