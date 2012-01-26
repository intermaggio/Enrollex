class Course < ActiveRecord::Base
  belongs_to :organization

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :organization_id
end
