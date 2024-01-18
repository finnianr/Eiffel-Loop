note
	description: "[
		${TP_QUOTED_STRING} optimized for ${ZSTRING} source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 14:05:45 GMT (Wednesday 8th November 2023)"
	revision: "5"

deferred class
	TP_ZSTRING_QUOTED_STRING

inherit
	TP_QUOTED_STRING
		undefine
			core, string_scope
		redefine
			as_code, default_unescaped_string, i_th_code
		end

	TP_OPTIMIZED_FOR_ZSTRING

feature {NONE} -- Implementation

	as_code (uc: CHARACTER_32): NATURAL
		do
			Result := Codec.as_z_code (uc)
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

end