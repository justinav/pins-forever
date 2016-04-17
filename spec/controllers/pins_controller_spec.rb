require 'spec_helper'
RSpec.describe PinsController do
	describe "GET index" do
		it 'renders index template' do
			get :index
			expect(response).to render_template("index")
			expect(assigns[:pins]).to eq(Pin.all)
		end
	end

	before(:each) do
	  @user = FactoryGirl.create(:user)
	  login(@user)
	end

	after(:each) do
	  if !@user.destroyed?
	    @user.destroy
	  end
	end

	describe "When user is logged out" do
		before(:each) do
		  logout(@user)
		end
		it 'index redirects to login view' do
			get :index
			expect(response.redirect?).to be(true)
		end
		it 'will not render new view' do
			get :new
			expect(response.success?).to be(false)
		end
		it 'edit redirects to login view' do
			@pin = Pin.first
			get :edit, :id => @pin.id
			expect(response.redirect?).to be(true)
		end
	end

	#
	#    NEW
	#

	describe "GET new" do
		it 'renders new view with pins' do
			get :new
			expect(response.success?).to be(true)
			expect(response).to render_template(:new)
			expect(assigns(:pin)).to be_a_new(Pin)
		end
	end

	describe "POST create" do
		before(:each) do
			@pin_hash = {
				title: "Rails Wizard",
				url: "http://railswizard.org",
				slug: "rails-wizard",
				text: "A fun and helpful Rails Resource",
				category: "rails"
			}
		end

		after(:each) do
			pin = Pin.find_by_slug("rails-wizard")
			if !pin.nil?
				pin.destroy
			end
		end

		it 'if creates valid post' do
			post :create, pin: @pin_hash
			expect(response.redirect?).to be(true)
			expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
			expect(response).to redirect_to(pin_url(assigns(:pin)))
		end

		it 'if creates invalid post' do
			@pin_hash.delete(:title)
			post :create, pin: @pin_hash
			expect(response).to render_template(:new)
		  expect(assigns[:errors].present?).to be(true)
		end

	end

	#
	#    EDIT & UPDATE
	#

	describe "GET edit" do
		before(:each) do
			@pin = Pin.first
			get :edit, :id => @pin.id
		end

		it {expect(response.success?).to be(true)}
		it {expect(response).to render_template(:edit)}
		it {expect(assigns(:pin)).to eq(@pin)}
	end

	describe "PUT update" do
		before(:each) do
			@pin = Pin.last
			@pin_hash = {
				title: "Rails Wizard",
				url: "http://railswizard.org",
				slug: "rails-wizard",
				text: "A fun and helpful Rails Resource",
				category: "rails"
			}
		end

		after(:each) do
			pin = Pin.find_by_slug("rails-wizard")
			if !pin.nil?
				pin.destroy
			end
		end

		context "when valid" do
			before { put :update, :pin => @pin_hash, :id => @pin.id }

			it {expect(response).to redirect_to pin_path}
			it {expect(Pin.find_by_slug("rails-wizard").present?).to be(true)}
			it {expect(response).to redirect_to(pin_url(assigns(:pin)))}
		end

		context "when invalid" do
			before {put :update, :pin => {:title => ""},:id => @pin.id}

			it {expect(response).to render_template(:edit)}
			it {expect(assigns[:errors].present?).to be(true)}
		end

	end

end