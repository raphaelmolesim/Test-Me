require 'spec_helper'

describe Question do
  
  context "A question (in general)" do
    
    before :each do
      @question = Question.new
      @question.knowledge_id = 1
      @question.description = "some description"
    end

    specify "should be invalid without a knowledge" do
      @question.knowledge_id = nil
      @question.should_not be_valid
      @question.errors[:knowledge_id].first.should == "is required"
      @question.knowledge_id = 1
      @question.should be_valid
    end

    specify "should be invalid without a description" do
      @question.description = nil
      @question.should_not be_valid
      @question.errors[:description].first.should == "is required"
      @question.description = "some description"
      @question.should be_valid
    end

  end
  
end
