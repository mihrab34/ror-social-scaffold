require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context 'Validation tests' do
    subject { Friendship.new }
    let(:friend1) { User.create(name: 'Sender', email: 'sender@gmail.com', password: 'password') }
    let(:friend2) { User.create(name: 'Receiver', email: 'receiver@gmail.com', password: 'password') }
  end

  it 'valid with both sender and reciever' do
    subject.friend1 = friend1
    subject.friend2 = friend2
    expect(subject).to be_valid
  end

  it 'not valid without a sender' do
    subject.friend2 = friend2
    expect(subject).to_not be_valid
  end

  it 'not valid without a reciever' do
    subject.friend1 = friend1
    expect(subject).to_not be_valid
  end

  context 'Associations tests' do
    it 'Belongs to User' do
      should belong_to(:user)
    end

    it 'Belongs to Friend as a User' do
      should belong_to(:friend).class_name('User')
    end
  end

  context 'Custom Validation tests' do
    subject { Friendship.new }
    let(:friend1) { User.create(name: 'Sender', email: 'sender@gmail.com', password: 'password') }
    let(:friend2) { User.create(name: 'Receiver', email: 'receiver@gmail.com', password: 'password') }

    it 'validates against duplicate friendship' do
      friend1.friendships.build(reciever: reciever, confirmed: false).save
      subject.friend1 = friend1
      subject.friend2 = friend2
      error_message = 'Validation failed: This relationship already exists'
      expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
    end

    it 'validates against self-friendship' do
      subject.friend1 = friend1
      subject.friend2 = friend2
      expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
