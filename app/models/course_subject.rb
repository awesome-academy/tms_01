class CourseSubject < ApplicationRecord
  belongs_to :course
  belongs_to :subject

  validates :course_id, presence: true
  validates :subject_id, presence: true

  scope :subjects_of_course, ->(course_id) do
    joins(:course, :subject)
      .select("subjects.*").where("course_id = ?", course_id)
  end
end
