note
	description: "[
		Object with procedures to be called from C
		See also: EL_C_TO_EIFFEL_CALLBACK_STRUCT
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-04 10:58:30 GMT (Saturday 4th July 2015)"
	revision: "3"

deferred class
	EL_C_CALLABLE

feature {NONE} -- Initialization

	make
			--
		do
			create c_callbacks_struct.make_filled (default_pointer, call_back_routines.count, 2)
		end

feature -- Access

	pointer_to_c_callbacks_struct: POINTER
			-- Pointer to struct with Eiffel callback target(s) and procedure(s)
		require
			callback_target_set: is_callback_target_set
		do
			Result := c_callbacks_struct.area.base_address
		end

feature -- Element change

	set_gc_protected_callbacks_target (target: EL_GC_PROTECTED_OBJECT)
			-- Fill C array of Eiffel call back structs

			--		typedef struct {
			--			Eiffel_procedure_t basic;
			--			Eiffel_procedure_t full;
			--		} Exception_handlers_t;

			-- Note: target.item is actually a pointer to the Current object
			-- protected from garbage collection relocation by EL_GC_PROTECTED_OBJECT
		local
			row: INTEGER; routine_pointers: like call_back_routines
		do
			routine_pointers := call_back_routines
			from row := 1 until row > routine_pointers.count loop
				c_callbacks_struct [row, 1] := target.item 				-- frozen address of Current object
				c_callbacks_struct [row, 2] := routine_pointers [row] -- address of frozen procedure in Current
				row := row + 1
			end
		end

feature -- Basic operations

	protect_C_callbacks
			-- Protect C callbacks from garbage collection for current object
		do
			Protected_objects.put (create {EL_GC_PROTECTED_OBJECT}.make (Current))
			set_gc_protected_callbacks_target (Protected_objects.item)
		end

	unprotect_C_callbacks
			--
		do
			Protected_objects.item.unprotect
			Protected_objects.remove
		end

feature --Contract support

	is_callback_target_set: BOOLEAN
			--
		do
			Result := not c_callbacks_struct.is_empty
		end

feature {NONE} -- Implementation

	c_callbacks_struct: ARRAY2 [POINTER]
		-- Overlays an array of the C struct shown:

		-- typedef struct {
		--		EIF_REFERENCE p_object;
		--		EIF_PROCEDURE p_procedure;
		--	} Eiffel_procedure_t;

	Protected_objects: ARRAYED_STACK [EL_GC_PROTECTED_OBJECT]
			--
		once
			create Result.make (1)
		end

	call_back_routines: ARRAY [POINTER]
			-- redefine with addresses of frozen procedures
		deferred
		end

feature {NONE} -- Constants

	Empty_call_back_routines: ARRAY [POINTER]
		once
			Result := << default_pointer >>
		end

end
