class AuthController < ApplicationController
  
  include AuthHelper

  def login
    unless session[:expa_token] == nil 
      redirect_to '/search_tool/index'
    end
  end

  def auth_expa(email=params[:my_email], senha=params[:my_password]) 
    url = 'https://auth.aiesec.org/users/sign_in' #Store the url for authenticate at EXPA
    agent = Mechanize.new {|a| a.ssl_version, a.verify_mode = 'TLSv1',OpenSSL::SSL::VERIFY_NONE} #Initialize an instance to start to work with mechanize
    page = agent.get(url)
    aiesec_form = page.form() #Selects the form on the page by its name. However this form doens't have a name
    aiesec_form.field_with(:name => 'user[email]').value = email #Set the email field with the args of this function
    aiesec_form.field_with(:name => 'user[password]').value = senha #Set the password field with the seccond arg of this function
    page = agent.submit(aiesec_form, aiesec_form.buttons.first) #submit the form
    
    if page.code.to_s == '200' #Verify if the page's code is 200, which means its all right
      cj = agent.cookie_jar  #Store the cookie at cj variable
      if cj.jar['experience.aiesec.org'] == nil  #Verify if inside the cookie exist an experience.aiesec.org
        render 'error' #If its nil redirect to the error page
      else
        session[:expa_token] = cj.jar['experience.aiesec.org']['/']["expa_token"].value
        redirect_to '/search_tool/index'
      end
    end

    
  end 

  def error
  end

  def logout
    session[:expa_token] = nil
    redirect_to '/auth/login'
  end

end
