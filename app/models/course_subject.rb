class CourseSubject < ApplicationRecord
  belongs_to :course
  belongs_to :subject

  validates :course_id, presence: true
  validates :subject_id, presence: true

  scope :subjects_of_course, (lambda do |course_id|
    joins(:course, :subject)
      .select("subjects.*").where("course_id = ?", course_id)
  end)

  scope :subject_id_on_course, (lambda do |course_id|
    joins(:subject)
      .select("subjects.id").where("course_id = ?", course_id)
  end)
end
