class Knowledge < ActiveRecord::Base
  belongs_to :user
  has_many :questions, :dependent => :delete_all, :validate => true
  
  validates_presence_of :name, :message => 'is required'
  validates_presence_of :user_id, :message => 'is required'
  
  def self.create_based_on_file file, name, user_id
    knowledge = Knowledge.new(:name => name, :user_id => user_id)
    return knowledge if not knowledge.save
    
    clean_file = file.gsub("\r\n", "<breakline>").gsub("\n", "<breakline>")
    br_in_sequel = /\<breakline\>(\s|\t)*\<breakline\>/  
    while not clean_file.slice(br_in_sequel).nil? do
      clean_file.gsub!(br_in_sequel, "<breakline>") 
    end
    
    clean_file.split("<breakline>").each do |line|
      knowledge.questions << Question.create({ 
        :description => line.gsub("Q:", "").strip, 
        :knowledge_id => knowledge.id}) if line.start_with? "Q:"

      knowledge.questions.last.answers << Answer.create({ 
        :description => line.gsub("A:", "").strip, 
        :question_id => knowledge.questions.last.id }) if line.start_with? "A:"

    end
    knowledge
  end
end
