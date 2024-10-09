note
	description: "C functions found in `eif_*.h' headers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-09 11:29:24 GMT (Wednesday 9th October 2024)"
	revision: "3"

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

feature -- Type properties

	eif_decoded_type_id (type_id: INTEGER): INTEGER
		-- the `EIF_TYPE_INDEX` id from the `eif_decoded_type` C call.
		external
			"C inline use <eif_eiffel.h>"
		alias
			"(EIF_INTEGER_32) eif_decoded_type((EIF_TYPE_INDEX) $type_id).id"
		end

	eif_type_flags (type_id: INTEGER): NATURAL_16
		-- struct c_node.cn_flags for `type_id' with additional flags `is_special' and `is_tuple'
		-- at 0x8 and 0x4 respectively
		external
			"C inline use <eif_eiffel.h>"
		alias
			"{
				EIF_TYPE_INDEX dtype = To_dtype(eif_decoded_type ($type_id).id);
				// Mask out the tuple code using
				EIF_NATURAL_16 result = (EIF_NATURAL_16) (System(dtype).cn_flags & 0xFF00);
				EIF_BOOLEAN is_special_type = EIF_TEST(
					(dtype == egc_sp_bool) ||
					(dtype == egc_sp_char) ||
					(dtype == egc_sp_wchar) ||
					(dtype == egc_sp_uint8) || (dtype == egc_sp_uint16) || (dtype == egc_sp_uint32) || (dtype == egc_sp_uint64) ||
					(dtype == egc_sp_int8) || (dtype == egc_sp_int16) || (dtype == egc_sp_int32) || (dtype == egc_sp_int64) ||
					(dtype == egc_sp_real32) || (dtype == egc_sp_real64) ||
					(dtype == egc_sp_pointer) ||
					(dtype == egc_sp_ref)
				);
				if (is_special_type > 0) result = result | 0x80;
				if (EIF_TEST(dtype == (EIF_TYPE_INDEX) egc_tup_dtype) > 0) result = result | 0x40;
				return result;
			}"
		end

	eif_type_size (type_id: INTEGER): INTEGER
		-- struct c_node.cn_flags for `type_id'
		external
			"C inline use <eif_malloc.h>"
		alias
			"(EIF_INTEGER)EIF_Size(To_dtype((EIF_TYPE_INDEX)$type_id))"
		end

	eif_generic_parameter_count (type_id: INTEGER): INTEGER
		-- struct c_node.cn_flags for `type_id'
		external
			"C inline use <eif_built_in.h>"
		alias
			"(EIF_INTEGER)eif_gen_count_with_dftype((EIF_TYPE_INDEX)$type_id)"
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