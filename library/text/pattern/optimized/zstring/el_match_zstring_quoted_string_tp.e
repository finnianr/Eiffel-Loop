note
	description: "[
		[$source EL_MATCH_QUOTED_STRING_TP] optimized for [$source ZSTRING] source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 11:21:51 GMT (Monday 14th November 2022)"
	revision: "1"

deferred class
	EL_MATCH_ZSTRING_QUOTED_STRING_TP

inherit
	EL_MATCH_QUOTED_STRING_TP
		redefine
			as_code, buffer_scope, default_unescaped_string, i_th_code
		end

	EL_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_CODEC

feature {NONE} -- Implementation

	as_code (uc: CHARACTER_32): NATURAL
		do
			Result := Codec.as_z_code (uc)
		end

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

end