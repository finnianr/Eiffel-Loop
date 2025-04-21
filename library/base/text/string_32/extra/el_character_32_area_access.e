note
	description: "[
		Provide access to unexported attributes ${READABLE_STRING_32}.area_lower and ${READABLE_STRING_32}.area_upper
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 17:22:40 GMT (Sunday 20th April 2025)"
	revision: "2"

class
	EL_CHARACTER_32_AREA_ACCESS

inherit
	STRING_32_ITERATION_CURSOR
		rename
			area_first_index as index_lower,
			area_last_index as index_upper,
			make as set_target
		export
			{NONE} all
			{ANY} index_lower, index_upper
		end

	EL_STRING_32_CONSTANTS

	EL_TYPED_POINTER_ROUTINES_I

create
	make_empty

feature {NONE} -- Initialization

	make_empty
		do
			set_target (Empty_string_32)
		end

feature -- Access

	get_area (str: READABLE_STRING_32): like area
		do
			Result := str.area
		end

	get_lower (str: READABLE_STRING_32; index_lower_ptr: TYPED_POINTER [INTEGER]): like area
		do
			Result := str.area; put_integer_32 (str.area_lower, index_lower_ptr)
		end

	get (str: READABLE_STRING_32; index_lower_ptr, index_upper_ptr: TYPED_POINTER [INTEGER]): like area
		do
			Result := str.area; put_integer_32 (str.area_lower, index_lower_ptr)
			put_integer_32 (str.area_upper, index_upper_ptr)
		end
end