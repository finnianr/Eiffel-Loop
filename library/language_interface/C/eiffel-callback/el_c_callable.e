note
	description: "[
		Object with procedures to be called from C
		See also: EL_C_TO_EIFFEL_CALLBACK_STRUCT
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_C_CALLABLE

feature {NONE} -- Initialization

	make
			--
		deferred
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
			-- Implement this procedure to fill in C callbacks struct
			-- with callback target and pointers to procedures declared as 'frozen'

			-- Example:

			--	c_callbacks_struct := <<
			--		target.item, $my_exception_handler,
			--		target.item, $my_message_printer,
			--		target.item, $my_whatever,
			--	>>
			-- Note: target.item is actually a pointer to the Current object
			-- protected from garbage collection relocation by EL_GC_PROTECTED_OBJECT

		deferred
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

	c_callbacks_struct: ARRAY [POINTER]
		-- struct of C pointers to Eiffel callback target(s) and procedure(s)


	Protected_objects: ARRAYED_STACK [EL_GC_PROTECTED_OBJECT]
			--
		once
			create Result.make (1)
		end

end
