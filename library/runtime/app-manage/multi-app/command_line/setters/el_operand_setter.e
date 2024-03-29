note
	description: "Validates and sets tuple operands for the basic types, strings and paths"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_OPERAND_SETTER [G]

inherit
	EL_MAKE_OPERAND_SETTER [G]
		redefine
			is_convertible, make, put_reference, value, value_description
		end

	EL_MODULE_CONVERT_STRING
		export
			{EL_FACTORY_CLIENT} Convert_string
		end

create
	make

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_argument: like argument)
		require else
			valid_type: Convert_string.has_converter ({G})
		do
			Precursor (a_argument)
			if Convert_string.has_converter ({G})
				and then attached {like converter} Convert_string.found_item as c
			then
				converter := c
			end
		end

feature {NONE} -- Implementation

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := converter.is_convertible (string_value)
		end

	put_reference (a_value: like value)
		do
			converter.put_tuple_item (operands, a_value, index)
		end

	value (str: ZSTRING): G
		do
			Result := converter.as_type (str)
		end

	value_description: ZSTRING
		do
			Result := converter.type_description
		end

feature {NONE} -- Internal attributes

	converter: EL_READABLE_STRING_GENERAL_TO_TYPE [G]

end