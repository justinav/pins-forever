class Pin < ActiveRecord::Base
  validates_presence_of :title, :url, :slug, :text
  validates_uniqueness_of :slug

  belongs_to :category

end