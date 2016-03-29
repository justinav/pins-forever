require "spec_helper"

# let!(:admin) { FactoryGirl.create(:admin) }
# before { subject.stub(current_user: admin, authenticate_user!: true) }

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login(@user)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(@user.first_name)
    expect(rendered).to match(@user.last_name)
    expect(rendered).to match(@user.email)
  end
end
