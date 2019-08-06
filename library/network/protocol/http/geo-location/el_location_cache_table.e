note
	description: "Geographical location lookup table for ip number"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_LOCATION_CACHE_TABLE

inherit
	HASH_TABLE [ZSTRING, NATURAL]
		rename
			has as is_location_cached
		end

	EL_MODULE_WEB

	EL_MODULE_IP_ADDRESS

	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Element change

	cache_location (ip_number: NATURAL; lio: EL_LOGGABLE)
		do
			if not is_location_cached (ip_number) then
				extend_for (ip_number)
				lio.put_character ('.')
			end
		end

feature -- Access

	location (ip_number: NATURAL): ZSTRING
		do
			if has_key (ip_number) then
				Result := found_item
			else
				extend_for (ip_number)
				if has_key (ip_number) then
					Result := found_item
				else
					create Result.make_empty
				end
			end
		end

feature {NONE} -- Implementation

	extend_for (ip_number: NATURAL)
		local
			done: BOOLEAN
		do
			Web.open (IP_api_template #$ [Ip_address.to_string (ip_number), location_type])
			from done := False until done loop
				Web.read_string_get
				if Web.has_error then
					extend ("<unknown>", ip_number)
					done := True

				elseif Web.last_string.has_substring (Ratelimited) then
					Execution_environment.sleep (500)
				else
					extend (create {ZSTRING}.make_from_utf_8 (Web.last_string), ip_number)
					done := True
				end
			end
			Web.close
		end

	location_type: STRING
		deferred
		end

feature {NONE} -- Constants

	IP_api_template: ZSTRING
		-- example: https://ipapi.co/91.196.50.33/country_name/
		-- Possible error: {"reason": "RateLimited", "message": "", "wait": 1.0, "error": true}
		once
			Result := "https://ipapi.co/%S/%S/"
		end

	RateLimited: STRING = "RateLimited"

end
