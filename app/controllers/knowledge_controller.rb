class KnowledgeController < ApplicationController
  def test
  end

  def manage
    @knowledge = Knowledge.find_all_by_user_id current_user.id
  end

  def upload
    file = params[:knowledge][:file]
    puts File.read(file.path)
    redirect_to :action => "manage"
  end

end
