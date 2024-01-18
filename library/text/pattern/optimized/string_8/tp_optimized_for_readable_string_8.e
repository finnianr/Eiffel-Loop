note
	description: "[
		Pattern match routines optimized for strings conforming to ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 14:00:54 GMT (Wednesday 8th November 2023)"
	revision: "5"

deferred class
	TP_OPTIMIZED_FOR_READABLE_STRING_8

inherit
	TP_SHARED_OPTIMIZED_FACTORY

	EL_STRING_8_CONSTANTS

	EL_SHARED_STRING_8_BUFFER_SCOPES

feature {NONE} -- Implementation

	core: TP_OPTIMIZED_FACTORY
		do
			Result := Factory_readable_string_8
		end

	i_th_is_single_quote (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
			-- `True' if i'th character exhibits property
		do
			Result := text [i] = '%''
		end

	i_th_is_digit (i: INTEGER_32; text: READABLE_STRING_8): BOOLEAN
			-- `True' if i'th character is digit
		do
			Result := text [i].is_digit
		end

	i_th_is_space (i: INTEGER_32; text: READABLE_STRING_8): BOOLEAN
			-- `True' if i'th character is white space
		do
			Result := text [i].is_space
		end

end