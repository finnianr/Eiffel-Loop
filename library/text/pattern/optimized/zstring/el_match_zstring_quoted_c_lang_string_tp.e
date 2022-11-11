note
	description: "[
		[$source EL_MATCH_QUOTED_C_LANG_STRING_TP] optimized for [$source ZSTRING] source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-11 9:16:29 GMT (Friday 11th November 2022)"
	revision: "3"

class
	EL_MATCH_ZSTRING_QUOTED_C_LANG_STRING_TP

inherit
	EL_MATCH_QUOTED_C_LANG_STRING_TP
		redefine
			buffer_scope, default_unescaped_string, i_th_code, i_th_is_quote, unescaped_code
		end

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Deferred

	buffer_scope: like Reuseable.string
		do
			Result := Reuseable.string
		end

	default_unescaped_string: STRING_GENERAL
		do
			Result := Empty_string
		end

	i_th_code (i: INTEGER_32; text: ZSTRING): NATURAL
			-- `True' if i'th character exhibits property
		do
			Result := text.z_code (i)
		end

	i_th_is_quote (i: INTEGER_32; text: ZSTRING; a_quote: CHARACTER_32): BOOLEAN
			-- `True' if i'th character exhibits property
		do
			Result := text [i] = a_quote.to_character_8
		end

	unescaped_code (text: ZSTRING; start_index, end_index: INTEGER): NATURAL
		local
			l_count: INTEGER
		do
			l_count := end_index - start_index + 1
			if l_count = 2 then
				Result := unicode_to_z_code (Code_table [text.item_8 (end_index)].to_natural_32)
			end
		end

end