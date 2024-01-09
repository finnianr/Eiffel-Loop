note
	description: "C functions found in `eif_*.h' headers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:25:32 GMT (Sunday 7th January 2024)"
	revision: "1"

deferred class
	EL_EIFFEL_C_API

inherit
	EL_C_API

feature {NONE} -- Object management

	eif_adopt (obj: ANY): POINTER
			-- Adopt object `obj'
		external
			"C [macro %"eif_macros.h%"]"
		end

	eif_wean (obj: POINTER)
			-- eif_wean object `obj'.
		external
			"C [macro %"eif_macros.h%"]"
		end

	eif_freeze (obj: ANY): POINTER
			-- Prevents garbaged collector from moving object
		require
			obj_not_void: attached obj
		external
			"c [macro <eif_macros.h>] (EIF_OBJECT): EIF_REFERENCE"
		end

	eif_unfreeze (ptr: POINTER)
			-- Allows object to be moved by the gc now.
		require
			ptr_attached: is_attached (ptr)
		external
			"c [macro <eif_macros.h>] (EIF_REFERENCE)"
		end

feature {NONE} -- Directory

	eif_dir_close (dir_ptr: POINTER)
			-- Close the directory `dir_ptr'.
		external
			"C use %"eif_dir.h%""
		end

	eif_dir_next (dir_ptr: POINTER): POINTER
			-- Return pointer to the next entry in the current iteration.
		external
			"C use %"eif_dir.h%""
		end

	eif_dir_open (dir_name: POINTER): POINTER
			-- Open the directory `dir_name'.
		external
			"C signature (EIF_FILENAME): EIF_POINTER use %"eif_dir.h%""
		end

	eif_dir_rewind (dir_ptr: POINTER; dir_name: POINTER): POINTER
			-- Rewind the directory `dir_ptr' with name `a_name' and return a new directory traversal pointer.
		external
			"C signature (EIF_POINTER, EIF_FILENAME): EIF_POINTER use %"eif_dir.h%""
		end

end