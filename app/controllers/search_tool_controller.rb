require 'csv'
require 'net/http'

class SearchToolController < ApplicationController
  include SearchToolHelper

  def index
  end
  
  def upload(file=params[:file], country=params[:country], code_area=params[:code_area])
  	path = file.path()
  	$links = make_csv(path, country)
  	$path1 = file.path()
  	redirect_to '/search_tool/index'
  end

  def download
  	
  end

  

end
