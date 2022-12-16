note
	description: "[
		Example of a class that exemplifies the
		[https://en.wikipedia.org/wiki/Don%27t_repeat_yourself DRY principle] using class reflection.
		Contrast 25 lines with [$source MY_WET_CLASS].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-15 8:44:43 GMT (Thursday 15th December 2022)"
	revision: "8"

class
	MY_DRY_CLASS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		export
			{ANY} field_table
		end

	EL_SETTABLE_FROM_STRING_32
		rename
			make_from_table as make,
			to_table as data_export
		end

create
	make, make_default

feature -- Access

	boolean: BOOLEAN

	double: DOUBLE

	integer: INTEGER

	natural: NATURAL

	real: REAL

	string: STRING

	string_32: STRING_32
end