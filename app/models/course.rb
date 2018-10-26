class Course < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects

  validates :title, presence: true,
    length: {maximum: Settings.course.title_max_length}
  validates :description, presence: true,
    length: {maximum: Settings.course.description_max_length}
end