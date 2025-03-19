note
	description: "Type category constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-17 11:12:06 GMT (Monday 17th March 2025)"
	revision: "2"

deferred class
	EL_TYPE_CATEGORY_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Categories

	C_readable_string_8: NATURAL_8 = 1

	C_readable_string_32: NATURAL_8 = 2

	C_el_path: NATURAL_8 = 3

	C_el_path_steps: NATURAL_8 = 4

	C_path: NATURAL_8 = 5

	C_type_any: NATURAL_8 = 6
		-- TYPE [ANY]

feature {NONE} -- Numeric Categories

	C_integer: NATURAL_8 = 7

	C_natural: NATURAL_8 = 8

	C_real: NATURAL_8 = 9

end