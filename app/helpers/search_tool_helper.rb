require 'csv'
require 'net/http'

module SearchToolHelper
	def make_csv(file, country, code)
		read_sheet = CSV.read("#{file}")
		links_array = Array.new
		read_sheet.each do |l|	
			links_array << l[0].to_s.split("/").last
		end
		file_name = "#{country}'s_st_contacts.csv"
		CSV.open(file_name, "wb") do |csv|
			csv << ["Name", "E-mail Address","Mobile Phone"]
			links_array.each do |id|		
				request = "https://gis-api.aiesec.org:443/v1/people/#{id}.json?access_token=#{session[:expa_token]}"
				resp = Net::HTTP.get_response(URI.parse(request))
				data = resp.body
				current_person = JSON.parse(data)
				if current_person['contact_info']
					if current_person['contact_info']['phone'] and current_person['contact_info']['phone'] != ""
						phone = current_person['contact_info']['phone'].delete("-").delete(" ").delete("+").delete("(").delete(")")
						if phone[0]=='0'
							phone[0]=''
						end 
						unless phone[0...code.length]==code
							phone = code.chomp+phone
						end
						$test_code = code
						phone.insert(0,"+")
					end
					email = current_person['contact_info']['email']
					if current_person['contact_info'] == nil
						csv << [current_person['full_name']+"#{country}-ST", "", ""]

					elsif phone == nil and email 	
						csv << [current_person['full_name']+"#{country}-ST", email,"" ]

					elsif phone and email == nil
						csv << [current_person['full_name']+"#{country}-ST", "", phone ]

					else
						csv << [current_person['full_name']+"#{country}-ST", email, phone]
					end

				end
			end
		end

		return file_name
	end
end
