note
	description: "[
		[$source TP_BASIC_QUOTED_STRING] optimized for [$source ZSTRING] source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:28:40 GMT (Saturday 3rd December 2022)"
	revision: "4"

class
	TP_ZSTRING_BASIC_QUOTED_STRING

inherit
	TP_BASIC_QUOTED_STRING
		undefine
			core, unescaped_code
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
