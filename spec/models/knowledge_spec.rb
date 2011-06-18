require 'spec_helper'

class ActiveRecord::Base
  def save
    if self.valid?
      self.id = 1
      return true
    end
    false 
  end
end

describe Knowledge do
  
  context "A knowledge (in general)" do

    before :each do
      @knowledge = Knowledge.new
      @knowledge.name = 'some name'
      @knowledge.user_id = 1
    end

    specify "should be invalid without a name" do
      @knowledge.name = nil
      @knowledge.should_not be_valid
      @knowledge.errors[:name].first.should == "is required"
      @knowledge.name = 'some name'
      @knowledge.should be_valid
    end

    specify "should be invalid without a user_id" do
      @knowledge.user_id = nil
      @knowledge.should_not be_valid
      @knowledge.errors[:user_id].first.should == "is required"
      @knowledge.user_id = 1
      @knowledge.should be_valid
    end
    
  end
  
  context "A knowledge should be created based on file" do
    
    before :each do
      @user_id = 2
      @name = "sample 1"
    end
  
    context "based in a simple file" do
      before :each do
        @question_stub = Question.new({ 
          :description => "Bom dia!", :knowledge_id => 1
        })
        @question_stub.id = 2
        Question.stub!(:create).and_return(@question_stub)
        @answer_stub = Answer.new({ 
          :description => "Dzien dobry!", :question_id => @question_stub.id 
        })
        Answer.stub!(:create).and_return(@answer_stub)
        @file = "Q: Bom dia!\r\nA: Dzien Dobry!"
      end
  
      it "should set his own name" do
        knowledge = Knowledge.create_based_on_file @file, @name, @user_id
        knowledge.name.should == "sample 1"
      end

      it "should create the object in the database" do
        knowledge = Knowledge.create_based_on_file @file, @name, @user_id
        knowledge.id.should == 1
      end
  
      it "should create a question based in a string" do
        knowlegde = Knowledge.create_based_on_file(@file, @name, @user_id)
        knowlegde.questions.first.description.should == "Bom dia!"
        knowlegde.questions.first.knowledge_id.should == 1
      end
  
      it "should create a question and answer based in a string" do
        knowlegde = Knowledge.create_based_on_file(@file, @name, @user_id)
        question = knowlegde.questions.first
        question.answers.first.description.should == "Dzien dobry!"
        question.answers.first.question_id.should == 2
      end

    end
    
    context "based in a complex file" do
      before :each do
        @question_stub = Question.new({ 
          :description => "Eu estou bem.", :knowledge_id => 1
        })
        @question_stub.id = 2
        Question.stub!(:create).and_return(@question_stub)
        @answer_stub_1 = Answer.new({ 
          :description => "Mam sie dobze.", :question_id => @question_stub.id 
        })
        @answer_stub_2 = Answer.new({ 
          :description => "Jestem dobra.", :question_id => @question_stub.id 
        })
        Answer.stub!(:create).and_return(@answer_stub_1, @answer_stub_2)
        @file = "Q: Eu estou bem.\r\nA: Mam sie dobze.\r\nA: Jestem dobra."
      end
    
      it "should create the questions with mutiple answers based in a string" do
        knowlegde = Knowledge.create_based_on_file(@file, @name, @user_id)
    
        knowlegde.questions.first.description.should == "Eu estou bem."
        knowlegde.questions.first.knowledge_id.should == 1
        question = knowlegde.questions.first
        question.answers.first.description.should == "Mam sie dobze."
        question.answers.first.question_id.should == 2
        question.answers.last.description.should == "Jestem dobra."
        question.answers.last.question_id.should == 2
      end
    end
   
    context "with support to different kinds of line break" do
      before :each do
        @question_stub = Question.new({ 
          :description => "Bom dia!", :knowledge_id => 1
        })
        @question_stub.id = 2
        Question.stub!(:create).and_return(@question_stub)
        @answer_stub = Answer.new({ 
          :description => "Dzien dobry!", :question_id => @question_stub.id 
        })
        Answer.stub!(:create).and_return(@answer_stub)
        @file = "Q: Bom dia!\n\n\nA: Dzien Dobry!\r\nQ: Bom dia!\nA: Dzien Dobry!"
      end
  
      it "should remove consecutives linebreaks" do
        knowlegde = Knowledge.create_based_on_file(@file, @name, @user_id)
        knowlegde.id.should == 1
        knowlegde.questions.first.description.should == "Bom dia!"
        knowlegde.questions.first.knowledge_id.should == 1
        knowlegde.questions.last.description.should == "Bom dia!"
        knowlegde.questions.last.knowledge_id.should == 1
        question = knowlegde.questions.first
        question.answers.first.description.should == "Dzien dobry!"
        question.answers.first.question_id.should == 2
        question = knowlegde.questions.last
        question.answers.first.description.should == "Dzien dobry!"
        question.answers.first.question_id.should == 2
      end
  
    end
    
  end
end