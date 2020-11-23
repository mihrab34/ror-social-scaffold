class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def user_is_not_equal_friend
    errors.add(:friend_id, "can't be same as user") if user_id == friend_id
  end
end
