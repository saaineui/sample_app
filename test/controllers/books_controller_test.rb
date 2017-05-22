require 'test_helper'

class BooksControllerTest < ActionController::TestCase

    def setup
        @public_book = books(:public)
        @read_user = users(:read)
        @admin_user = users(:admin)
    end
    
  test "should get show" do
    get :show, id: @public_book
    assert_response :success
  end

  test "should get show with front-matter location data" do
    get :show, id: @public_book, location: 3
    assert_response :success
  end

  test "should get show with chapter location data" do
    get :show, id: @public_book, location: 5
    assert_response :success
  end

  test "should get show with location and scroll data" do
    get :show, id: @public_book, location: 5, scroll: 50
    assert_response :success
  end

  test "should get show with out of range location" do
    get :show, id: @public_book, location: 500, scroll: 50
    assert_response :success
  end

  test "should get show with out of range scroll" do
    get :show, id: @public_book, location: 5, scroll: -2
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to root_url
  end

  test "should redirect new when not logged in" do
    get :new
    assert_redirected_to root_url
  end

  test "should redirect create when not logged in" do
    post :create
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @public_book
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @public_book, book: { title: "AAAAAA" }
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Book.count' do
        delete :destroy, id: @public_book
    end
    assert_redirected_to root_url
  end

  test "should redirect upload when not logged in" do
    get :upload, id: @public_book
    assert_redirected_to root_url
  end

  test "should redirect create when logged in as read-only user" do
    log_in_as(@read_user)
    post :create
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in as read-only user" do
    log_in_as(@read_user)
    get :edit, id: @public_book
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as read-only user" do
    log_in_as(@read_user)
    patch :update, id: @read_user, book: { title: "AAAAAA" }
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@read_user)
    assert_no_difference 'Book.count' do
        delete :destroy, id: @public_book
    end
    assert_redirected_to root_url
  end

  test "should redirect upload when logged in as a non-admin" do
    log_in_as(@read_user)
    get :upload, id: @public_book
    assert_redirected_to root_url
  end

  test "should get new when logged in as admin" do
    log_in_as(@admin_user)
    get :new
    assert_response :success
  end

  test "should post create when logged in as admin" do
    log_in_as(@admin_user)      
    @book = Book.new
    post :create, id: @book, book: { title: "", author: "" }
    assert_response :success
  end

  test "should get edit when logged in as admin" do
    log_in_as(@admin_user)
    get :edit, id: @public_book
    assert_response :success
  end

  test "should post update when logged in as admin" do
    log_in_as(@admin_user)
    post :update, id: @public_book, book: { title: "", author: "" }
    assert_response :success
  end

  test "should get upload when logged in as admin" do
    log_in_as(@admin_user)
    get :upload, id: @public_book
    assert_response :success
  end

  test "destroy should redirect to books index and delete book and sections" do
    log_in_as(@admin_user)
    assert_difference 'Book.count', -1 do
        delete :destroy, id: @public_book
    end
  end
    
end
