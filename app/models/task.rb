class Task < ApplicationRecord
  belongs_to :subject
  has_many :user_tasks, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
end
