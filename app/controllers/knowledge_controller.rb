class KnowledgeController < ApplicationController
   before_filter :authenticate_user!

  def manage
    @knowledge = Knowledge.find_all_by_user_id current_user.id
  end

  def upload
    file = File.read params["file"].path, { :encoding => "UTF-16LE:UTF-8" }
    file.gsub!("\xEF\xBB\xBF".force_encoding("UTF-8"), '')
    puts "==>" + file
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
  
  def get_sound
    apiKey = 'db78d86b01b3e7bb321c349e96252f58'
    word = params['word'].gsub("!", "").gsub(".", "").gsub("?", "")
    url = "http://apifree.forvo.com/key/#{apiKey}/format/xml/action/standard-pronunciation/word/#{}"
    puts "==>#{url}"
    require 'net/https'
    require 'open-uri'
    uri = URI.parse(URI.encode(url))
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.start { |request| request.get(url) }
    require "rexml/document"
    puts response.body
    xmlDoc = REXML::Document.new response.body
    
    render :text => xmlDoc.elements['//pathmp3'].first;
  end 
end
