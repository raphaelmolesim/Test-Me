require 'json'

module KnowledgeHelper
  
  def parse_to_json questions
    hash = {}
    questions.each do |question|
      hash.store question.description, question.answers.collect { |a| a.description }
    end
    hash.to_json.html_safe.gsub("\"","'")
  end
  
end
