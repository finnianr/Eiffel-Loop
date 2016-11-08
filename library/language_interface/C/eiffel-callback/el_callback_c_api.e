note
	description: "Summary description for {EL_CALLBACK_C_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-03 15:30:40 GMT (Monday 3rd October 2016)"
	revision: "2"

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

end
