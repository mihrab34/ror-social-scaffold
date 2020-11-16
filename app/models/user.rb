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

  # Users who requested to be friends (needed for notifications )
  has_many :friend_requests, through: :inverted_friendships, source: :friend

  # Users who need to confirm friendship
  has_many :pending_friendships, -> { where(confirmed: false) }, class_name: 'Friendship', foreign_key: 'user_id'

  # Find user friends only by user_id from friendship table 
  has_many :confirmed_friendships, -> { where(confirmed: true) }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friends, through: :confirmed_friendships

  # Method to check if a given user is a friend
  def friend?(user)
    friends.include?(user)
  end
end
