ENV['RAILS_ENV'] ||= 'test'

#require 'simplecov'
#SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include ActionDispatch::TestProcess

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    # Returns true if a test user is logged in.
    def logged_in?
      !session[:user_id].nil?
    end

    # Logs in a test user.
    def log_in_as(user, options = {})
      password = options[:password] || 'password'
      if integration_test?
        post login_path, params: {
          session: { email: user.email, password: password }
        }
      else
        session[:user_id] = user.id
      end
    end

    def create_pages_json
      pages = create_pages
      pages = assign_sig_order_and_position(pages)
      pages.to_json
    end
    
    def create_images_json
      [
        {
          'src': 'https://example.com/ch1.png', 'height': '54px', 'margin_top': '0px', 
          'margin_bottom': '9px', 'section_order': '1', 'n': 0, 'tagType': 'H2'
        },        
        {
          'src': 'https://example.com/image.png', 'height': '107px', 'margin_top': '0px', 
          'margin_bottom': '19px', 'section_order': '2', 'n': 0, 'tagType': 'FIGURE'
        },      
        {
          'src': 'https://example.com/image.png', 'height': '107px', 'margin_top': '0px', 
          'margin_bottom': '19px', 'section_order': '8', 'n': 0, 'tagType': 'FIGURE'
        },
        {
          'src': 'https://example.com/image.png', 'height': '107px', 'margin_top': '0px', 
          'margin_bottom': '19px', 'section_order': '8', 'n': 1, 'tagType': 'FIGURE'
        }      
      ].to_json
    end

    private

    # Returns true inside an integration test.
    def integration_test?
      defined?(follow_redirect!)
    end

    def create_pages
      pages = [
        { order: 'title', page_num: 1, pages_before: 0, signature: 1, signature_order: 1, page_position: 1 }, 
        { order: 'blank', page_num: 2, pages_before: 0, signature: 1, signature_order: 1, page_position: 2 }, 
        { order: 'epigraph', page_num: 3, pages_before: 0, signature: 1, signature_order: 2, page_position: 1 },
        { order: 'blank', page_num: 4, pages_before: 0, signature: 1, signature_order: 2, page_position: 2 }
      ]
      pages + (5..32).map { |page_num| { order: 1, page_num: page_num, pages_before: page_num - 1, signature: 1 } }
    end

    def assign_sig_order_and_position(pages)
      # front left (FL = 0), front right (FR = 1), back left (BL = 2), back right (BR = 3)
      (4..31).each do |n|
        if n < 16
          pages[n][:signature_order] = n / 2 + 1
          pages[n][:page_position] = n.even? ? 1 : 2
        else
          pages[n][:signature_order] = (31 - n) / 2 + 1
          pages[n][:page_position] = n.even? ? 3 : 0
        end
      end
      pages
    end
  end
end
