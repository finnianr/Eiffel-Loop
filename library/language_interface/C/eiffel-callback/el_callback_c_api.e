note
	description: "Callback c api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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