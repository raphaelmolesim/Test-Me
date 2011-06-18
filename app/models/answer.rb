class Answer < ActiveRecord::Base
  belongs_to :question
  
  validates_presence_of :question_id, :message => "is required"
  validates_presence_of :description, :message => "is required"
end
