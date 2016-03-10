note
	description: "[
		C struct for C callbacks to Eiffel
		
			typedef struct {
				EIF_REFERENCE p_object;
				EIF_PROCEDURE p_procedure;
			} Eiffel_procedure_t;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_C_CALLBACK

inherit
	ARRAY [POINTER]
		rename
			make as make_array
		end

create
	make

convert
	base_address: {POINTER}

feature {NONE} -- Initialization

	make (procedure_ptr: POINTER)
			--
		do
			make_array (1, 2)
			put (procedure_ptr, 2)
		end

feature -- Access

	base_address: POINTER
			-- pointer to C struct

			--	typedef struct {
			--		EIF_REFERENCE p_object;
			--		EIF_PROCEDURE p_procedure;
			--	} Eiffel_procedure_t;

		do
			Result := area.base_address
		end

feature -- Element change

	set_target (target: EL_GC_PROTECTED_OBJECT)
			--
		do
			put (target.item, 1)
		end

end
