note
	description: "Routines for managing Eiffel objects when making calls to a C API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-14 10:15:14 GMT (Friday 14th July 2023)"
	revision: "7"

class
	EL_CALLBACK_C_API

feature {NONE} -- C Externals

	c_eif_freeze (obj: ANY): POINTER
			-- Prevents garbaged collector from moving object
		require
			obj_not_void: attached obj
		external
			"c [macro <eif_eiffel.h>] (EIF_OBJECT): EIF_REFERENCE"
		alias
			"eif_freeze"
		end

	c_eif_unfreeze (ptr: POINTER)
			-- Allows object to be moved by the gc now.
		require
			ptr_attached: not ptr.is_default_pointer
		external
			"c [macro <eif_eiffel.h>] (EIF_REFERENCE)"
		alias
			"eif_unfreeze"
		end

	eif_wean (obj: POINTER)
			-- eif_wean object `obj'.
		external
			"C [macro %"eif_macros.h%"]"
		alias
			"eif_wean"
		end

	eif_adopt (obj: ANY): POINTER
			-- Adopt object `obj'
		external
			"C [macro %"eif_macros.h%"]"
		alias
			"eif_adopt"
		end

end