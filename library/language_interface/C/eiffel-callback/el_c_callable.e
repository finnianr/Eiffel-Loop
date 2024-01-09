note
	description: "[
		Ancestor for classes that are intended to handle callbacks from a C language routine. 
		See also: [$source EL_C_TO_EIFFEL_CALLBACK_STRUCT]
	]"
	instructions: "[
		To enable the descendant object item for callbacks, assign the result of the function
		`new_callback' to a temporary variable before invoking the C routine which makes callbacks.

		**Example**
			execute (connection: EL_HTTP_CONNECTION)
				local
					callback: like new_callback
				do
					reset
					callback := new_callback
					connection.set_curl_option_with_data (callback_curl_option, callback_address)
					connection.set_curl_option_with_data (callback_curl_data_option, pointer_to_c_callbacks_struct)
					connection.do_transfer
					callback.release
				end

	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:11:09 GMT (Sunday 7th January 2024)"
	revision: "10"

deferred class
	EL_C_CALLABLE

inherit
	EL_MEMORY_ROUTINES

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

	set_fixed_address (fixed_address_ptr: POINTER)
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
				c_callbacks_struct [row, 1] := fixed_address_ptr		-- frozen address of Current object
				c_callbacks_struct [row, 2] := routine_pointers [row] -- address of frozen procedure in Current
				row := row + 1
			end
		end

feature --Contract support

	is_callback_target_set: BOOLEAN
			--
		do
			Result := not c_callbacks_struct.is_empty
		end

feature {EL_C_TO_EIFFEL_CALLBACK_STRUCT} -- Factory

	new_callback: EL_CALLBACK_FIXER_I
		do
			if {MEMORY}.collecting then
				create {EL_CALLBACK_FIXER} Result.make (Current)
			else
				create {EL_SPECIAL_CALLBACK_FIXER} Result.make (Current)
			end
		end

feature {NONE} -- Implementation

	c_callbacks_struct: ARRAY2 [POINTER]
		-- Overlays an array of the C struct shown:

		-- typedef struct {
		--		EIF_REFERENCE p_object;
		--		EIF_PROCEDURE p_procedure;
		--	} Eiffel_procedure_t;

		-- Eiffel_procedure_t procedures [n];

	call_back_routines: ARRAY [POINTER]
			-- redefine with addresses of frozen procedures
		deferred
		end

feature {NONE} -- Constants

	Empty_call_back_routines: ARRAY [POINTER]
		once
			Result := << default_pointer >>
		end

note
	descendants: "[
			EL_C_CALLABLE*
				[$source EL_EXPAT_XML_PARSER]
					[$source EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM]
					[$source EL_EXPAT_XML_WITH_CTRL_Z_PARSER]
				[$source EL_VTD_CALLABLE_EXCEPTIONS]
				[$source EL_HTTP_COMMAND]*
					[$source EL_DOWNLOAD_HTTP_COMMAND]*
						[$source EL_STRING_DOWNLOAD_HTTP_COMMAND]
							[$source EL_GET_HTTP_COMMAND]
							[$source EL_HEAD_HTTP_COMMAND]
							[$source EL_POST_HTTP_COMMAND]
						[$source EL_FILE_DOWNLOAD_HTTP_COMMAND]
	]"
end