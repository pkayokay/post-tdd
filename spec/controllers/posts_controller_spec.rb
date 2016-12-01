require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  
  describe "posts#destroy action" do
    it "shoulnd't allow users who didn't create the gram to destroy it" do
      post = FactoryGirl.create(:post)
      user = FactoryGirl.create(:user)
      sign_in user

      delete :destroy, id: post.id
      expect(response).to have_http_status(:forbidden)
    end

    it "should let unauthenticated users destroy a post" do
      post = FactoryGirl.create(:post)
      delete :destroy, id: post.id
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy posts" do
      post = FactoryGirl.create(:post)
      sign_in post.user

      delete :destroy, id: post.id
      expect(response).to redirect_to root_path
      post = Post.find_by_id(post.id)
      expect(post).to eq nil
    end

    it "should return a 404 caption if we cannot find a gram with the id that is specified" do
      post = FactoryGirl.create(:post)
      sign_in post.user

      delete :destroy, id: 'POOP'
      expect(response).to have_http_status(:not_found)
    end
  end


  describe "posts#update action" do
    it "shouldn't let users who didn't create the post update it" do
      post = FactoryGirl.create(:post)
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, id: post.id, post: {title: 'Hello', caption: 'World'}
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users create a post" do
      post = FactoryGirl.create(:post)
      patch :update, id: post.id, gram: {title: 'Hello', caption: 'World'}
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update posts" do
      post = FactoryGirl.create(:post, title: 'Initial Value', caption: 'Initial Value')
      sign_in post.user

      patch :update, id: post.id, post: {title: 'Changed', caption: 'Changed'}
      expect(response).to redirect_to post_path(post)
      post.reload
      expect(post.title).to eq 'Changed'
      expect(post.caption).to eq 'Changed'
    end

    it "should have a http 404 error if the post cannot be found" do
      post = FactoryGirl.create(:post, title: 'Initial Value', caption: 'Initial Value')
      sign_in post.user

      patch :update, id: 'POOP', post: {title: 'Changed', caption: 'Changed'}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      post = FactoryGirl.create(:post, title: 'Initial Value', caption: 'Initial Value')
      sign_in post.user

      patch :update, id: post.id, post: {title: '', caption: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      post.reload
      expect(post.title).to eq 'Initial Value'
      expect(post.caption).to eq 'Initial Value'
    end
  end


  describe "posts#edit action" do
    it "shouldn't let a user who did not create the post to edit a post" do
      post = FactoryGirl.create(:post)
      user = FactoryGirl.create(:user)
      sign_in user

      get :edit, id: post.id
      expect(response).to have_http_status(:forbidden)
    end
    
    it "shouldn't let unauthenticated users edit a post" do
      post = FactoryGirl.create(:post)
      get :edit, id: post.id
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the post is found" do
      post = FactoryGirl.create(:post)
      sign_in post.user

      get :edit, id: post.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error caption if the post is not found" do
      post = FactoryGirl.create(:post)
      sign_in post.user
      
      get :edit, id: 'TACOS'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "posts#show action" do
    it "should successfully show the page if the post is found" do
      post = FactoryGirl.create(:post)
      get :show, id: post.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the post is not found" do
      get :show, id: 'TACOS'
      expect(response).to have_http_status(:not_found)
    end
  end
  describe "posts#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


  describe "posts#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new 
      expect(response).to have_http_status(:success)
    end
  end


  describe "posts#create action" do
    it "should require users to be logged in" do
      post :create, post: {title: 'Hello', caption: 'World'}
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully create a new post in our database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, post: {title: 'Hello', caption: 'World', picture: fixture_file_upload("/picture.png", 'image/png')}
      expect(response).to redirect_to root_path

      post = Post.last
      expect(post.title).to eq('Hello')
      expect(post.caption).to eq('World')
      expect(post.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      post_count = Post.count
      post :create, post: {title: '', caption: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(post_count).to eq Post.count
    end
  end
end
