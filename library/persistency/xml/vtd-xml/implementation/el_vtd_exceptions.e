note
	description: "Vtd exceptions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_VTD_EXCEPTIONS

inherit
	EXCEPTIONS
		redefine
			out
		end

	EL_C_CALLABLE
		undefine
			out
		redefine
			make
		end

	EL_VTD_CONSTANTS
		undefine
			out
		end

	EL_MODULE_LIO
		undefine
			out
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create type_description.make_empty
			create message.make_empty
			create sub_message.make_empty
		end

feature -- Access

	message: STRING

	out: STRING
			--
		do
			create Result.make_from_string ("VTD ERROR: ")
			Result.append (type_description)

			Result.append (" [")
			Result.append_string (message)
			if not sub_message.is_empty then
				Result.append (" (")
				Result.append (sub_message)
				Result.append (")")
			end
			Result.append_character (']')
		end

	sub_message: STRING

	type_description: STRING

feature -- Element change

	set_message (a_message: STRING)
			--
		do
			message := a_message
		end

	set_sub_message (a_sub_message: STRING)
			--
		do
			sub_message := a_sub_message
		end

	set_type_description (exception_type: INTEGER)
			--
		do
			type_description := Exception_type_descriptions [exception_type + 1]
		end

feature -- Basic operations

	alert
			--
		do
			lio.put_string_field ("VTD-XML ERROR", type_description)
			lio.put_new_line

			lio.put_string ("DETAILS: ")
			lio.put_string (message)
			if not sub_message.is_empty then
				lio.put_string (", ")
				lio.put_string (sub_message)
			end
			lio.put_new_line
		end

feature {NONE} -- Implementation

	frozen on_exception_basic (exception_type: INTEGER; evx_message: POINTER)
			-- Handles C exception defined in vtdNav.c

			--	void throwException2 (enum exception_type et, char *msg){
			--		exception e;
			--		e.et = et;
			--		e.subtype = BASIC_EXCEPTION;
			--		e.msg = msg;
			--		Throw e;
			--	}
		require
			evx_message_attached: is_attached (evx_message)
		do
			set_type_description (exception_type)
			set_message (create {STRING}.make_from_c (evx_message))
			alert
			raise (out)
		end

	frozen on_exception_full (exception_type: INTEGER; evx_message, evx_sub_message: POINTER)
			-- Handles C exception defined in vtdNav.c

			--	void throwException(enum exception_type et, int sub_type, char* msg, char* submsg){
			--		exception e;
			--		e.et = et;
			--		e.subtype = sub_type;
			--		e.msg = msg;
			--		e.sub_msg = submsg;
			--		Throw e;
			--	}
		require
			evx_message_attached: is_attached (evx_message)
			evx_sub_message_not_void: is_attached (evx_sub_message)
		do
			set_type_description (exception_type)
			set_message (create {STRING}.make_from_c (evx_message))
			set_sub_message (create {STRING}.make_from_c (evx_sub_message))
			alert
			raise (out)
		end

feature {NONE} -- Constants

	Call_back_routines: ARRAY [POINTER]
		once
			Result := << $on_exception_basic, $on_exception_full >>
		end

end
