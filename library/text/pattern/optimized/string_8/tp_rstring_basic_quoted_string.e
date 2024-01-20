note
	description: "[
		${TP_BASIC_QUOTED_STRING} optimized for strings conforming to ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	TP_RSTRING_BASIC_QUOTED_STRING

inherit
	TP_BASIC_QUOTED_STRING
		undefine
			core
		redefine
			unescaped_code
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

create
	make

feature {NONE} -- Implementation

	unescaped_code (text: READABLE_STRING_8; start_index, end_index, sequence_count: INTEGER): NATURAL
		do
			if sequence_count = 2 then
				Result := text [end_index].natural_32_code
			end
		end

end