module AuthHelper

	def take_token(page, mehanize_client_agent)
		if page.code.to_s == '200' #Verify if the page's code is 200, which means its all right
		  cj = mehanize_client_agent.cookie_jar  #Store the cookie at cj variable
		  if cj.jar['experience.aiesec.org'] == nil  #Verify if inside the cookie exist an experience.aiesec.org
		    return "Can't grab the token" #If its nil redirect to the error page
		  else
		    #$token = cj.jar['experience.aiesec.org']['/']["expa_token"].value[44,64] #Take the token code for API. First version
		    token = cj.jar['experience.aiesec.org']['/']["expa_token"].value
		  	return token
		  end
		else
			return "Ain't no token"
		end
	end

end
