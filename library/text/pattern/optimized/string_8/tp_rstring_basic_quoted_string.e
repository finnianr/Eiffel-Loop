note
	description: "[
		${TP_BASIC_QUOTED_STRING} optimized for strings conforming to ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:26:39 GMT (Saturday 3rd December 2022)"
	revision: "4"

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
