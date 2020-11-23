class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships
  has_many :inverted_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friend_requests, through: :inverted_friendships, source: :friend
  has_many :pending_friendships, -> { where(confirmed: false) }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :confirmed_friendships, -> { where(confirmed: true) }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friends, through: :confirmed_friendships

  # Method to check if a given user is a friend
  def friend?(user)
    friends.include?(user)
  end

  def cancel_request(user)
    friendship = friendships.find { |f| f.friend_id == user.id }
    friendship.destroy
  end

  def confirm_friend(user)
    friendship = inverted_friendships.find { |f| f.user == user }
    friendship.confirmed = true
    friendship.save
  end

  def pending_friend?
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  def friend_requests
    inverted_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  end
end
