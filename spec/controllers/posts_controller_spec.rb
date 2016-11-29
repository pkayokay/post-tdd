require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully show the new form" do
      user = User.create(
        email: 'test@gmail.com',
        password: 'secretPass',
        password_confirmation: 'secretPass'
        )
      sign_in user

      get :new 
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, gram: {message: 'Hello'}
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully create a new post in our database" do
      user = User.create(
        email: 'test@gmail.com',
        password: 'secretPass',
        password_confirmation: 'secretPass'
        )
      sign_in user

      post :create, post: {message: 'Hello'}
      expect(response).to redirect_to root_path

      post = Post.last
      expect(post.message).to eq('Hello')
      expect(post.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = User.create(
        email: 'test@gmail.com',
        password: 'secretPass',
        password_confirmation: 'secretPass'
        )
      sign_in user

      post :create, post: {message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Post.count).to eq 0
    end
  end
end
