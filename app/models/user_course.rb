class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :user_id, presence: true
  validates :course_id, presence: true

  enum status: {unstart: 0, inprogress: 1, finish: 2}
end
