note
	description: "[
		Pattern match routines optimized for strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8

inherit
	EL_SHARED_OPTIMIZED_FACTORY

	EL_STRING_8_CONSTANTS

feature {NONE} -- Implementation

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