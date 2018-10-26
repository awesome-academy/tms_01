class UserSubject < ApplicationRecord
  belongs_to :user_course
  belongs_to :course_subject

  validates :user_course_id, presence: true
  validates :course_subject_id, presence: true

  enum status: {unstart: 0, inprogress: 1, finish: 2}
end
