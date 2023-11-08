note
	description: "[
		[$source TP_QUOTED_STRING] optimized for strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 14:09:18 GMT (Wednesday 8th November 2023)"
	revision: "5"

deferred class
	TP_RSTRING_QUOTED_STRING

inherit
	TP_QUOTED_STRING
		rename
			string_scope as string_8_scope
		undefine
			core, string_8_scope
		redefine
			default_unescaped_string, i_th_code
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

feature {NONE} -- Implementation

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