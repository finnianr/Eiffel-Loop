note
	description: "[
		Country and region fields parsed from JSON query `https://ipapi.co/<IP-address>/json'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 18:44:26 GMT (Thursday 11th July 2024)"
	revision: "12"

class
	EL_IP_ADDRESS_COUNTRY_REGION

inherit
	EL_IP_ADDRESS_COUNTRY
		redefine
			location, Field_hash, IP_api_template
		end

create
	make, make_from_json

feature -- Access

	location: ZSTRING
		-- country and region
		do
			Result := country_name + Separator + region
		end

feature -- API string fields

	region: ZSTRING
		-- region name (administrative division)

feature -- Constants

	IP_api_template: ZSTRING
		-- example: https://ipapi.co/91.196.50.33/json/
		-- Possible error: {"reason": "RateLimited", "message": "", "wait": 1.0, "error": true}
		once
			Result := "https://ipapi.co/%S/json"
		end

feature {NONE} -- Constants

	Field_hash: NATURAL
		once
			Result := 1966935048
		end

	Separator: ZSTRING
		once
			Result := ", "
		end

end