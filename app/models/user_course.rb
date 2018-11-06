class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :user_id, presence: true
  validates :course_id, presence: true

  enum status: {unstart: 0, inprogress: 1, finish: 2}

  scope :user_of_course_by_role, (lambda do |course_id, role|
    joins(:user, :course)
      .select("users.*")
      .where("course_id = ?", course_id).merge(role)
  end)

  scope :user_id_on_course, (lambda do |course_id|
    joins(:user)
      .select("users.id")
      .where(course_id: course_id)
  end)
end
