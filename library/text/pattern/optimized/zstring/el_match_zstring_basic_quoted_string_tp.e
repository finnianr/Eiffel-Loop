note
	description: "[
		[$source EL_MATCH_BASIC_QUOTED_STRING_TP] optimized for [$source ZSTRING] source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 16:53:23 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_ZSTRING_BASIC_QUOTED_STRING_TP

inherit
	EL_MATCH_BASIC_QUOTED_STRING_TP
		undefine
			unescaped_code
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING

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