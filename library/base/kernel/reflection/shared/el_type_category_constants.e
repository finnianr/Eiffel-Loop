note
	description: "Type category constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-03 13:27:32 GMT (Tuesday 3rd September 2024)"
	revision: "1"

deferred class
	EL_TYPE_CATEGORY_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	C_readable_string_8: NATURAL_8 = 1

	C_readable_string_32: NATURAL_8 = 2

	C_el_path: NATURAL_8 = 3

	C_el_path_steps: NATURAL_8 = 4

	C_path: NATURAL_8 = 5

	C_type_any: NATURAL_8 = 6

end