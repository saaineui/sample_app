ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include ActionDispatch::TestProcess

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # Returns true if a test user is logged in.
  def is_logged_in?
      !session[:user_id].nil?
  end

  # Logs in a test user.
  def log_in_as(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
        post login_path, session: { email:       user.email,
            password:    password,
            remember_me: remember_me }
        else
        session[:user_id] = user.id
    end
  end
    
  def create_pages_json
    pages = [
              {order: "title", page_num: 1, pages_before: 0, signature: 1, signature_order: 1, page_position: 1}, 
              {order: "epigraph", page_num: 2, pages_before: 1, signature: 1, signature_order: 2, page_position: 4}
      ]
    pages += (0..5).map { |order| {order: order, page_num: order+3, pages_before: order+2, signature: 1, signature_order: order+3, page_position: 3}}
    pages.to_json
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end

end
