note
	description: "[
		Pattern match routines optimized for strings of type ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "6"

deferred class
	TP_OPTIMIZED_FOR_ZSTRING

inherit
	TP_SHARED_OPTIMIZED_FACTORY

	EL_SHARED_ZSTRING_CODEC

	EL_ZSTRING_CONSTANTS

	STRING_HANDLER

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		end

	EL_SHARED_ZSTRING_BUFFER_SCOPES

feature {NONE} -- Implementation

	core: TP_OPTIMIZED_FACTORY
		do
			Result := Factory_zstring
		end

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