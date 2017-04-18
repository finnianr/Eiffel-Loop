note
	description: "Summary description for {EL_CURL_HEADER_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-07 15:02:50 GMT (Friday 7th April 2017)"
	revision: "1"

class
	EL_CURL_HEADER_TABLE

inherit
	HASH_TABLE [STRING, STRING]

	EL_SHARED_CURL_API
		undefine
			is_equal, copy
		end

create
	make_equal

feature {EL_HTTP_CONNECTION} -- Access

	to_curl_string_list: POINTER
		local
			header: STRING
		do
			create header.make (40)
			from start until after loop
				header.append (key_for_iteration); header.append_character (':')
				if not item_for_iteration.is_empty then
					header.append_character (' ')
					header.append (item_for_iteration)
				end
				Result := curl.extend_string_list (Result, header)
				header.wipe_out
				forth
			end
		end
end
