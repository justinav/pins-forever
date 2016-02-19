require 'spec_helper'
RSpec.describe PinsController do
	describe "GET index" do
		it 'renders the index template' do
			get :index
			expect(response).to render_template("index")
		end

		it 'populates @pins with all pins' do
			get :index
			expect(assigns[:pins]).to eq(Pin.all)
		end
	end

	#
	#    NEW
	#

	describe "GET new" do
		it 'responds with successfully' do
			get :new
			expect(response.success?).to be(true)
		end

		it 'renders the new view' do
			get :new
			expect(response).to render_template(:new)
		end

		it 'assigns an instance variable to a new pin' do
			get :new
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

		it 'responds with a redirect' do
			post :create, pin: @pin_hash
			expect(response.redirect?).to be(true)
		end

		it 'creates a pin' do
			post :create, pin: @pin_hash
			expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
		end

		it 'redirects to the show view' do
			post :create, pin: @pin_hash
			expect(response).to redirect_to(pin_url(assigns(:pin)))
		end

		it 'redisplays new form on error' do
			# The title is required in the Pin model, so we'll
			# delete the title from the @pin_hash in order
			# to test what happens with invalid parameters
			@pin_hash.delete(:title)
			post :create, pin: @pin_hash
			expect(response).to render_template(:new)
		end

		it 'assigns the @errors instance variable on error' do
		  # The title is required in the Pin model, so we'll
		  # delete the title from the @pin_hash in order
		  # to test what happens with invalid parameters
		  @pin_hash.delete(:title)
		  post :create, pin: @pin_hash
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

		it 'responds with successfully' do
			expect(response.success?).to be(true)
		end

		it 'renders the edit view' do
			expect(response).to render_template(:edit)
		end

		it 'assigns an instance variable to the pin' do
			expect(assigns(:pin)).to eq(@pin)
		end
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

		# if valid parameters are passed
		context "when valid" do
			before { put :update, :pin => @pin_hash, :id => @pin.id }

			it 'responds with a redirect following a PUT to /pins/:id/edit' do
				expect(response).to redirect_to pin_path
			end

			it 'edits a pin' do
				expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
			end

			it 'redirects to the edit view' do
				expect(response).to redirect_to(pin_url(assigns(:pin)))
			end
		end

		# if invalid parameters are passed
		context "when invalid" do
			before {put :update, :pin => {:title => ""},:id => @pin.id}

			it 'redisplays edit form on error' do
				# The title is required in the Pin model, so we'll
				# pass a blank title to test what happens with invalid parameters
				expect(response).to render_template(:edit)
			end

			it 'assigns the @errors instance variable on error' do
				# The title is required in the Pin model, so we'll
				# pass a blank title to test what happens with invalid parameters
				expect(assigns[:errors].present?).to be(true)
			end
		end

	end

end