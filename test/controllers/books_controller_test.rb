require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  def setup
    @public_book = books(:public)
    @read_user = users(:read)
    @admin_user = users(:admin)
    @form_data = {
      invalid: { title: '', author: '', subtitle: '', logo_url: '', copyright: '', 
                 epigraph: '', cover_image_url: '', background_image_url: '' },
      valid:   { title: 'MyString', author: 'MyString', subtitle: '', logo_url: 'MyString', 
                 copyright: '', epigraph: '', cover_image_url: 'MyString', background_image_url: '' }
    }    
  end
    
  test 'should get show' do
    get :show, params: { id: @public_book }
    assert_response :success
  end

  test 'should get show with front-matter location data' do
    get :show, params: { id: @public_book, location: 3 }
    assert_response :success
  end

  test 'should get show with chapter location data' do
    get :show, params: { id: @public_book, location: 5 }
    assert_response :success
  end

  test 'should get show with location and scroll data' do
    get :show, params: { id: @public_book, location: 5, scroll: 50 }
    assert_response :success
  end

  test 'should get show with out of range location' do
    get :show, params: { id: @public_book, location: 500, scroll: 50 }
    assert_response :success
  end

  test 'should get show with out of range scroll' do
    get :show, params: { id: @public_book, location: 5, scroll: -2 }
    assert_response :success
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_redirected_to login_url
  end

  test 'should redirect new when not logged in' do
    get :new
    assert_redirected_to login_url
  end

  test 'should redirect create when not logged in' do
    post :create
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    get :edit, params: { id: @public_book }
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch :update, params: { id: @public_book, book: { title: 'AAAAAA' } }
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Book.count' do
      delete :destroy, params: { id: @public_book }
    end
    assert_redirected_to login_url
  end

  test 'should redirect upload when not logged in' do
    get :upload, params: { id: @public_book }
    assert_redirected_to login_url
  end

  test 'should get show when logged in as read-only user' do
    log_in_as(@read_user)
    get :show, params: { id: @public_book }
    assert_response :success
  end

  test 'should redirect index when logged in as read-only user' do
    log_in_as(@read_user)
    get :index
    assert_redirected_to root_url
  end

  test 'should redirect new when logged in as read-only user' do
    log_in_as(@read_user)
    get :new
    assert_redirected_to root_url
  end

  test 'should redirect create when logged in as read-only user' do
    log_in_as(@read_user)
    post :create
    assert_redirected_to root_url
  end

  test 'should redirect edit when logged in as read-only user' do
    log_in_as(@read_user)
    get :edit, params: { id: @public_book }
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as read-only user' do
    log_in_as(@read_user)
    patch :update, params: { id: @read_user, book: { title: 'AAAAAA' } }
    assert_redirected_to root_url
  end

  test 'should redirect destroy when logged in as a read-only user' do
    log_in_as(@read_user)
    assert_no_difference('Book.count') { delete :destroy, params: { id: @public_book } }
    assert_redirected_to root_url
  end

  test 'should redirect upload when logged in as a read-only user' do
    log_in_as(@read_user)
    get :upload, params: { id: @public_book }
    assert_redirected_to root_url
  end

  test 'should get show when logged in as admin' do
    log_in_as(@admin_user)
    get :show, params: { id: @public_book }
    assert_response :success
  end

  test 'should get index when logged in as admin' do
    log_in_as(@admin_user)
    get :index
    assert_response :success
  end

  test 'should get new when logged in as admin' do
    log_in_as(@admin_user)
    get :new
    assert_response :success
  end

  test 'should redirect to new when post empty create' do
    log_in_as(@admin_user)      
    @book = Book.new
    post :create, params: { id: @book, book: @form_data[:invalid] }
    assert_template 'books/new'
    assert_select '#error_explanation p', count: 4
  end

  test 'should post create when logged in as admin' do
    log_in_as(@admin_user)      
    post :create, params: { book: @form_data[:valid] }
    assert_redirected_to upload_book_path(Book.last)
  end

  test 'should get edit when logged in as admin' do
    log_in_as(@admin_user)
    get :edit, params: { id: @public_book }
    assert_response :success
  end

  test 'should redirect to edit with errors when post empty update' do
    log_in_as(@admin_user)
    post :update, params: { id: @public_book, book: @form_data[:invalid] }
    assert_template 'books/edit'
    assert_select '#error_explanation p', count: 4
  end

  test 'should post update when logged in as admin' do
    log_in_as(@admin_user)
    post :update, params: { id: @public_book, book: @form_data[:valid] }
    assert_template 'books/edit'
    assert_select '#error_explanation p', count: 0
  end

  test 'should get upload when logged in as admin' do
    log_in_as(@admin_user)
    get :upload, params: { id: @public_book }
    assert_response :success
  end

  test 'destroy should redirect to books index and delete book and sections' do
    log_in_as(@admin_user)
    assert_difference('Book.count', -1) { delete :destroy, params: { id: @public_book } }
  end
    
  test 'galley should render' do
    get :galley, params: { id: @public_book }
    assert_response :success
  end
  
  test 'print front should render' do
    post :print, params: { id: @public_book, position: 'Front', pages: create_pages_json }
    assert_response :success
  end
  
  test 'print back should render' do
    post :print, params: { id: @public_book, position: 'Back', pages: create_pages_json }
    assert_response :success
  end
end
