note
	description: "[
		[$source EL_MATCH_BASIC_QUOTED_STRING_TP] optimized for strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_STRING_8_BASIC_QUOTED_STRING_TP

inherit
	EL_MATCH_BASIC_QUOTED_STRING_TP
		redefine
			unescaped_code
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8
	
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