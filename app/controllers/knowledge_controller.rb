class KnowledgeController < ApplicationController
   before_filter :authenticate_user!

  def manage
    @knowledge = Knowledge.find_all_by_user_id current_user.id
  end

  def upload
    file = File.read(params["file"].path)
    puts file.class
    name = params["name"]
    @knowledge = Knowledge.create_based_on_file(file, name, current_user.id) 
    render :action => "show"
  end
  
  def show
    @knowledge = Knowledge.find(params[:id])
  end
  
  def delete
    Knowledge.find(params[:id]).delete
    redirect_to :action => "manage"
  end

  def select
    @knowledge = Knowledge.find_all_by_user_id current_user.id
  end
  
  def test
     knowledge_ids = params[:knowledge].collect { |k, v| k.to_i }
     @questions = knowledge_ids.collect { |id| Question.find_all_by_knowledge_id(id) }
     @questions.flatten!
  end
  
  def file_layout
  end 
end
