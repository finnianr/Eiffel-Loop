note
	description: "[
		[$source EL_MATCH_QUOTED_STRING_TP] optimized for strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_MATCH_STRING_8_QUOTED_STRING_TP

inherit
	EL_MATCH_QUOTED_STRING_TP
		redefine
			buffer_scope, default_unescaped_string, i_th_code
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8

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

end