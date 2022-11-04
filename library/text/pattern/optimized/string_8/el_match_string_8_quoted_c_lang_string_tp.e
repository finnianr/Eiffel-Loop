note
	description: "[
		[$source EL_MATCH_QUOTED_C_LANG_STRING_TP] optimized for strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-01 9:20:28 GMT (Tuesday 1st November 2022)"
	revision: "2"

class
	EL_MATCH_STRING_8_QUOTED_C_LANG_STRING_TP

inherit
	EL_MATCH_QUOTED_C_LANG_STRING_TP
		redefine
			buffer_scope, default_unescaped_string, i_th_code, i_th_is_quote, unescaped_code
		end

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Implementation

	buffer_scope: like Reuseable.string_8
		do
			Result := Reuseable.string_8
		end

	default_unescaped_string: STRING_GENERAL
		do
			Result := Empty_string_8
		end

	i_th_code (i: INTEGER_32; text: READABLE_STRING_GENERAL): NATURAL
			-- `True' if i'th character exhibits property
		do
			Result := text [i].natural_32_code
		end

	i_th_is_quote (i: INTEGER_32; text: READABLE_STRING_8; a_quote: CHARACTER_32): BOOLEAN
			-- `True' if i'th character exhibits property
		do
			Result := text [i] = a_quote.to_character_8
		end

	unescaped_code (text: READABLE_STRING_8; start_index, end_index: INTEGER): NATURAL
		local
			l_count: INTEGER
		do
			l_count := end_index - start_index + 1
			if l_count = 2 then
				Result := Code_table [text [end_index]].to_natural_32
			end
		end

end