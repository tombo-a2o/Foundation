# TODO: Change to be based on ActionController::API
class Api::BaseController < ActionController::Base
  layout 'api_base'
  before_action :setup_layout_elements

  def setup_layout_elements
    @errors = []
  end

  def error!(message)
    @errors << message
    nil
  end
end
