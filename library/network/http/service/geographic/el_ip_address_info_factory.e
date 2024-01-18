note
	description: "Factory for objects conforming to ${EL_IP_ADDRESS_GEOLOCATION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_IP_ADDRESS_INFO_FACTORY [G -> EL_IP_ADDRESS_GEOLOCATION create make, make_from_json end]

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_WEB

	EL_MODULE_IP_ADDRESS

feature -- Element change

	set_log (a_log: like log)
		do
			log := a_log
		end

feature {NONE} -- Implementation

	new_info (ip_number: NATURAL): G
		local
			done: BOOLEAN
		do
			Web.open (IP_api_template #$ [IP_address.to_string (ip_number)])
			Web.set_user_agent (Mozzilla_user_agent)
			from done := False until done loop
				Web.read_string_get
				if Web.has_error then
					create Result.make
					done := True

				elseif Web.last_string.has_substring (Ratelimited) then
					Execution_environment.sleep (500)
				else
					create Result.make_from_json (Web.last_string)
--					size_1 := Eiffel.deep_physical_size (Web.last_string)
--					size_2 := Result.deep_physical_size
					done := True
				end
			end
			Web.close
			if attached log as l then
				l.put_character ('.')
			end
		end

feature {NONE} -- Internal attributes

	log: detachable EL_LOGGABLE

feature {NONE} -- Constants

	IP_api_template: ZSTRING
		-- example: https://ipapi.co/91.196.50.33/json/
		-- Possible error: {"reason": "RateLimited", "message": "", "wait": 1.0, "error": true}
		once
			Result := "https://ipapi.co/%S/json"
		end

	Mozzilla_user_agent: STRING = "Mozilla/5.0 (platform; rv:geckoversion) Gecko/geckotrail Firefox/firefoxversion"

	RateLimited: STRING = "RateLimited"

end