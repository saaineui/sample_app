require 'test_helper'

class TasksTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = users(:admin)
    @read_user = users(:read)
    Spineless::Application.load_tasks
  end

  test "admin:adminify upgrades read user privileges to admin" do
    Rake::Task["admin:adminify"].invoke(@read_user.id)
    @read_user.reload
    assert @read_user.admin?
  end

  test "admin:downgrade revokes admin user privileges" do
    Rake::Task["admin:downgrade"].invoke(@admin_user.id)
    @admin_user.reload
    assert_not @admin_user.admin?
  end
end
