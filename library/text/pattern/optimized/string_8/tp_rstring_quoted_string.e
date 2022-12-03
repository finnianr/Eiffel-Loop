note
	description: "[
		[$source TP_QUOTED_STRING] optimized for strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:26:26 GMT (Saturday 3rd December 2022)"
	revision: "4"

deferred class
	TP_RSTRING_QUOTED_STRING

inherit
	TP_QUOTED_STRING
		undefine
			core
		redefine
			buffer_scope, default_unescaped_string, i_th_code
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

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
