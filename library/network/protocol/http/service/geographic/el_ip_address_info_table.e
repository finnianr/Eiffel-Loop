note
	description: "Information table for IP address and field code defined in [$source EL_GEOGRAPHIC_FIELDS_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-12 18:35:54 GMT (Tuesday 12th October 2021)"
	revision: "2"

class
	EL_IP_ADDRESS_INFO_TABLE

inherit
	EL_CACHE_TABLE [EL_IP_ADDRESS_INFO, NATURAL]
		rename
			make as make_cache
		end

	EL_MODULE_WEB

	EL_MODULE_IP_ADDRESS

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
		do
			make_cache (11, agent new_info)
		end

feature -- Element change

	set_log (a_log: like log)
		do
			log := a_log
		end

feature {NONE} -- Implementation

	new_info (ip_number: NATURAL): EL_IP_ADDRESS_INFO
		local
			done: BOOLEAN
		do
			Web.open (IP_api_template #$ [IP_address.to_string (ip_number)])
			Web.set_user_agent (Mozzilla_user_agent)
			from done := False until done loop
				Web.read_string_get
				if Web.has_error then
					create Result.make_default
					done := True

				elseif Web.last_string.has_substring (Ratelimited) then
					Execution_environment.sleep (500)
				else
					create Result.make_from_json (Web.last_string)
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

	Unknown: ZSTRING
		once
			Result := "<unknown>"
		end
end