class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :user_id, presence: true
  validates :course_id, presence: true

  enum status: {unstart: 0, inprogress: 1, finish: 2}

  scope :user_of_course_by_role, ->(course_id, role) do
    joins(:user, :course)
      .select("users.*")
      .where("course_id = ?", course_id).merge(role)
  end
end
