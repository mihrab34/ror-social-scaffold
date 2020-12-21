class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, foreign_key: 'user_id'
  has_many :inverted_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def friend_request?(friend)
    friend.friendships.find_by(friend_id: id).nil?
  end

  def friends?(friend)
    friendships.find_by(friend_id: friend.id).nil? && friend_request?(friend)
  end

  def confirmed_request?(friend)
    friendships.find_by(friend_id: friend.id).confirmed == true
  end
end
