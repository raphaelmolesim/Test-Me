require 'spec_helper'

describe Answer do
  context "A answer (in general)" do
    
    before :each do
      @answer = Answer.new
      @answer.question_id = 1
      @answer.description = "some description"
    end

    specify "should be invalid without a question" do
      @answer.question_id = nil
      @answer.should_not be_valid
      @answer.errors[:question_id].first.should == "is required"
      @answer.question_id = 1
      @answer.should be_valid
    end

    specify "should be invalid without a description" do
      @answer.description = nil
      @answer.should_not be_valid
      @answer.errors[:description].first.should == "is required"
      @answer.description = "some description"
      @answer.should be_valid
    end

  end
end
