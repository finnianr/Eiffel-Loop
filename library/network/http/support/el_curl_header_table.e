note
	description: "Curl header table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_CURL_HEADER_TABLE

inherit
	HASH_TABLE [STRING, STRING]

	EL_SHARED_CURL_API

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