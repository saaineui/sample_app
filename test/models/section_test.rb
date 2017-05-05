require 'test_helper'

class SectionTest < ActiveSupport::TestCase

    def setup
        @section = Section.new(title: "Functions", order: 3, chapter: 2, text: "Lorem ipsum", indexable: true)
    end
    
    test "should be valid" do
        assert @section.valid?
    end

    test "order should be present" do
        @section.order = nil
        assert_not @section.valid?
    end
    
end
