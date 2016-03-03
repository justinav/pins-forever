require 'spec_helper'

RSpec.describe UsersController, type: :controller do

  before(:each) do
    @user = FactoryGirl.build(:user)
  end
  after(:each) do
    if !@user.destroyed?
      @user.destroy
    end
  end
  let(:valid_attributes) {
    {
      first_name: @user.first_name,
      last_name: @user.last_name,
      email: @user.email,
      password: @user.password
    }
  }

  let(:invalid_attributes) {
    {
      first_name: @user.first_name,
      email: nil,
      password: @user.password
    }
  }

  describe "GET #show" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      post :authenticate, {email: @user.email, password: @user.password}
      get :show, {:id => user.to_param}
      expect(response).to render_template(:show)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET #new" do
    it "assigns a new user as @user" do
      post :authenticate, {email: @user.email, password: @user.password}
      get :new, {}
      expect(response).to render_template(:new)
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET #edit" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      post :authenticate, {email: @user.email, password: @user.password}
      get :edit, {:id => user.to_param}
      expect(response).to render_template(:edit)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {:user => valid_attributes}
          }.to change(User, :count).by(1)
        end

        it "assigns a newly created user as @user" do
          post :create, {:user => valid_attributes}
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user)).to be_persisted
        end

        it "redirects to the created user" do
          post :create, {:user => valid_attributes}
          expect(response).to redirect_to(User.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved user as @user" do
          post :create, {:user => invalid_attributes}
          expect(assigns(:user)).to be_a_new(User)
          expect(response).to render_template(:new)
        end
      end
    end

  describe "PUT #update" do
    context "with valid params" do
      it "assigns the requested user as @user" do
        user = User.create! valid_attributes
        post :authenticate, {email: @user.email, password: @user.password}
        put :update, {:id => user.to_param, :user => valid_attributes}
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        post :authenticate, {email: @user.email, password: @user.password}
        put :update, {:id => user.to_param, :user => valid_attributes}
        expect(response).to redirect_to(user)
      end
    end

    context "with invalid params" do
      it "assigns the user as @user" do
        user = User.create! valid_attributes
        post :authenticate, {email: @user.email, password: @user.password}
        put :update, {:id => user.to_param, :user => invalid_attributes}
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = User.create! valid_attributes
        post :authenticate, {email: @user.email, password: @user.password}
        put :update, {:id => user.to_param, :user => invalid_attributes}
        expect(response).to render_template('edit')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      post :authenticate, {email: @user.email, password: @user.password}
      expect {delete :destroy, {:id => user.to_param}}.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = User.create! valid_attributes
      post :authenticate, {email: @user.email, password: @user.password}
      delete :destroy, {:id => user.to_param}
      expect(response).to redirect_to(users_url)
    end
  end

  describe "GET login" do
    it "renders the login view" do
      get :login
      expect(response).to render_template(:login)
    end
  end

  describe "POST login" do
    it "when params valid" do
      post :authenticate, valid_attributes
      expect(@user.present?).to be(true)
    end

    it "when params not valid" do
      post :authenticate, invalid_attributes
      expect(response).to render_template(:login)
      expect([:error]).to be_present
    end
  end

end
