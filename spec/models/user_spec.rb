require "spec_helper"

RSpec.describe User, type: :model do

  it { should validate_presence_of(:first_name) }
  # should validate user
  # should have secure password
end
