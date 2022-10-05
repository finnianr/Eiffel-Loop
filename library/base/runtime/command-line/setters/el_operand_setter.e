note
	description: "Validates and sets tuple operands for the basic types, strings and paths"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 16:55:27 GMT (Wednesday 5th October 2022)"
	revision: "1"

class
	EL_OPERAND_SETTER [G]

inherit
	EL_MAKE_OPERAND_SETTER [G]
		redefine
			is_convertible, make, put_reference, value
		end

	EL_MODULE_CONVERT_STRING
		export
			{EL_FACTORY_CLIENT} Convert_string
		end

create
	make

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_make_routine: like make_routine; a_argument: like argument)
		require else
			valid_type: Convert_string.has_converter ({G})
		do
			Precursor (a_make_routine, a_argument)
			if Convert_string.has_converter ({G})
				and then attached {EL_READABLE_STRING_GENERAL_TO_TYPE [G]} Convert_string.found_item as c
			then
				converter := c
			end
		end

feature {NONE} -- Implementation

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := converter.is_convertible (string_value)
		end

	put_reference (a_value: like value; i: INTEGER)
		do
			converter.put_tuple_item (make_routine.operands, a_value, i)
		end

	value (str: ZSTRING): G
		do
			Result := converter.as_type (str)
		end

feature {NONE} -- Internal attributes

	converter: EL_READABLE_STRING_GENERAL_TO_TYPE [G]

end