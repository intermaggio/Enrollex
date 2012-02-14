class Course < ActiveRecord::Base
  belongs_to :organization

  validates_presence_of :name

  mount_uploader :image, CourseImage

  scope :featured, where(featured: true)

  has_many :days
  has_and_belongs_to_many :instructors, class_name: 'User', join_table: 'instructors_courses'

  before_save do
    self.lowname = self.name.downcase.gsub(' ', '_').gsub(/\W/, '')
  end
end
