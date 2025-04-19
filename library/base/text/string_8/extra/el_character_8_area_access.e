note
	description: "[
		Provide access to unexported attributes ${READABLE_STRING_8}.area_lower and ${READABLE_STRING_8}.area_upper
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 15:07:31 GMT (Saturday 19th April 2025)"
	revision: "1"

class
	EL_CHARACTER_8_AREA_ACCESS

inherit
	STRING_8_ITERATION_CURSOR
		rename
			area_first_index as index_lower,
			area_last_index as index_upper,
			make as set_target
		export
			{NONE} all
			{ANY} index_lower, index_upper
		end

	EL_STRING_8_CONSTANTS

	EL_TYPED_POINTER_ROUTINES_I

create
	make_empty

feature {NONE} -- Initialization

	make_empty
		do
			set_target (Empty_string_8)
		end

feature -- Access

	get_lower (str: READABLE_STRING_8; index_lower_ptr: TYPED_POINTER [INTEGER]): like area
		do
			Result := str.area; put_integer_32 (str.area_lower, index_lower_ptr)
		end

	get (str: READABLE_STRING_8; index_lower_ptr, index_upper_ptr: TYPED_POINTER [INTEGER]): like area
		do
			Result := str.area; put_integer_32 (str.area_lower, index_lower_ptr)
			put_integer_32 (str.area_upper, index_upper_ptr)
		end
end