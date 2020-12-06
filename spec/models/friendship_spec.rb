require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:each) do
    @friend1 = User.create(name: 'Sender', email: 'sender@gmail.com', password: 'password')
    @friend2 = User.create(name: 'Receiver', email: 'receiver@gmail.com', password: 'password')
  end

  context 'ActiveRecord Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name('User') }
  end
end
