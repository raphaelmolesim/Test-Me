class Question < ActiveRecord::Base
  belongs_to :knowledge
  has_many :answers, :dependent => :delete_all, :validate => true
  
  validates_presence_of :knowledge_id, :message => "is required"
  validates_presence_of :description, :message => "is required"
end
