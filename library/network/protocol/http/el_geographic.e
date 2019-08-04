note
	description: "Cached geopgraphic lookup of ip number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-04 12:37:06 GMT (Sunday 4th August 2019)"
	revision: "2"

class
	EL_GEOGRAPHIC

inherit
	HASH_TABLE [ZSTRING, NATURAL]
		export
			{NONE} all
		end

	EL_MODULE_WEB

	EL_MODULE_IP_ADDRESS

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_LIO

create
	make

feature -- Access

	location (ip_number: NATURAL): ZSTRING
		local
			done: BOOLEAN
		do
			if has_key (ip_number) then
				Result := found_item
			else
				create Result.make (50)
				across Variables as name loop
					if not Result.is_empty then
						Result.append_string (Separator)
					end
					Web.open (IP_api_template #$ [Ip_address.to_string (ip_number), name.item])
					from done := False until done loop
						Web.read_string_get
						if Web.last_string.has_substring (Ratelimited) then
							lio.put_new_line
							lio.put_string ("Waiting for ipapi.co ..")
							lio.put_new_line
							Execution_environment.sleep (500)
						else
							Result.append_utf_8 (Web.last_string)
							done := True
						end
					end
					Web.close
				end
				extend (Result, ip_number)
			end
		end

feature {NONE} -- Constants

	IP_api_template: ZSTRING
		-- example: https://ipapi.co/91.196.50.33/country_name/
		-- Possible error: {"reason": "RateLimited", "message": "", "wait": 1.0, "error": true}
		once
			Result := "https://ipapi.co/%S/%S/"
		end

	Variables: ARRAY [STRING]
		once
			Result := << "country_name", "region" >>
		end

	Separator: ZSTRING
		once
			Result := ", "
		end

	RateLimited: STRING = "RateLimited"

end
