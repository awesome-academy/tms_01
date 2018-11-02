class Subject < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects

  validates :title, presence: true,
    length: {maximum: Settings.subject.title_max_length}
  validates :description, presence: true,
    length: {maximum: Settings.subject.description_max_length}

  scope :latest, ->{order created_at: :desc}
end
