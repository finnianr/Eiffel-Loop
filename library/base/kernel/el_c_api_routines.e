note
	description: "[
		Base class for all C API routines and containing a number of common Eiffel C routines
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-04 20:23:51 GMT (Thursday 4th January 2024)"
	revision: "10"

class
	EL_C_API_ROUTINES

feature -- Status query

	is_attached (a_pointer: POINTER): BOOLEAN
		do
			Result := not a_pointer.is_default_pointer
		end

feature {NONE} -- C externals

	eif_adopt (obj: ANY): POINTER
			-- Adopt object `obj'
		external
			"C [macro %"eif_macros.h%"]"
		alias
			"eif_adopt"
		end

	eif_wean (obj: POINTER)
			-- eif_wean object `obj'.
		external
			"C [macro %"eif_macros.h%"]"
		alias
			"eif_wean"
		end

	eif_freeze (obj: ANY): POINTER
			-- Prevents garbaged collector from moving object
		require
			obj_not_void: attached obj
		external
			"c [macro <eif_macros.h>] (EIF_OBJECT): EIF_REFERENCE"
		alias
			"eif_freeze"
		end

	eif_unfreeze (ptr: POINTER)
			-- Allows object to be moved by the gc now.
		require
			ptr_attached: is_attached (ptr)
		external
			"c [macro <eif_macros.h>] (EIF_REFERENCE)"
		alias
			"eif_unfreeze"
		end
end