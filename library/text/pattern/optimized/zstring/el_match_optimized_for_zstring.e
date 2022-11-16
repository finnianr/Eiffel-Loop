note
	description: "[
		Pattern match routines optimized for strings of type [$source ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 17:03:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_MATCH_OPTIMIZED_FOR_ZSTRING

inherit
	EL_SHARED_OPTIMIZED_FACTORY

	EL_SHARED_ZSTRING_CODEC

	EL_ZSTRING_CONSTANTS

	STRING_HANDLER

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	i_th_is_single_quote (i: INTEGER; text: ZSTRING): BOOLEAN
			-- `True' if i'th character exhibits property
		do
			Result := text.item_8 (i) = '%''
		end

	i_th_is_space (i: INTEGER_32; text: ZSTRING): BOOLEAN
		-- `True' if i'th character is white space
		do
			Result := text.is_space_item (i)
		end

	i_th_is_numeric (i: INTEGER_32; text: ZSTRING): BOOLEAN
			-- `True' if i'th character is digit
		do
			Result := text.is_numeric_item (i)
		end
end