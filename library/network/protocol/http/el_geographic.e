note
	description: "Cached geopgraphic lookup of ip number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-03 18:09:33 GMT (Saturday 3rd August 2019)"
	revision: "1"

class
	EL_GEOGRAPHIC

inherit
	HASH_TABLE [ZSTRING, NATURAL]
		export
			{NONE} all
		end

	EL_MODULE_WEB

	EL_MODULE_IP_ADDRESS

create
	make

feature -- Access

	location (ip_number: NATURAL): ZSTRING
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
					Web.read_string_get
					Result.append_utf_8 (Web.last_string)
					Web.close
				end
				extend (Result, ip_number)
			end
		end

feature {NONE} -- Constants

	IP_api_template: ZSTRING
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

end
