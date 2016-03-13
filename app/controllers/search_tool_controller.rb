require 'csv'
require 'net/http'

class SearchToolController < ApplicationController
  include SearchToolHelper

  def index
  end
  
  def upload(file=params[:file], country=params[:country], code_area=params[:code_area])
  	path = file.path()
  	file4download = make_csv(path, country, code_area)
  	send_file file4download
  end

  def download
  	
  end

  

end
