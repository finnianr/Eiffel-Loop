note
	description: "[
		${TP_BASIC_QUOTED_STRING} optimized for ${ZSTRING} source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	TP_ZSTRING_BASIC_QUOTED_STRING

inherit
	TP_BASIC_QUOTED_STRING
		undefine
			core, unescaped_code, string_scope
		end

	TP_OPTIMIZED_FOR_ZSTRING

create
	make

feature {NONE} -- Implementation

	unescaped_code (text: ZSTRING; start_index, end_index, sequence_count: INTEGER): NATURAL
		do
			if sequence_count = 2 then
				Result := text.z_code (end_index)
			end
		end

end