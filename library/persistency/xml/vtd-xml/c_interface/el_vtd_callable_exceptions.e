note
	description: "VTD C callback exception routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-21 11:13:42 GMT (Wednesday 21st April 2021)"
	revision: "8"

class
	EL_VTD_CALLABLE_EXCEPTIONS

inherit
	EL_C_CALLABLE
		redefine
			make
		end

	EL_MODULE_EXCEPTION
		rename
			Exception as Mod_exception
		end

	EL_MODULE_LIO

	EL_VTD_CONSTANTS

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

feature {NONE} -- C call backs

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
			type_description := Exception.description (exception_type)
			create message.make_from_c (evx_message)
			sub_message.wipe_out
			put_error
			raise_exception
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
			type_description := Exception.description (exception_type)
			create message.make_from_c (evx_message)
			create sub_message.make_from_c (evx_sub_message)
			put_error
			raise_exception
		end

feature {NONE} -- Implementation

	put_error
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

	raise_exception
		do
			Mod_exception.raise_developer (Error_template, [type_description, message, sub_message])
		end

feature {NONE} -- Internal attributes

	message: STRING

	sub_message: STRING

	type_description: STRING

feature {NONE} -- Constants

	Call_back_routines: ARRAY [POINTER]
		once
			Result := << $on_exception_basic, $on_exception_full >>
		end

	Error_template: ZSTRING
		once
			Result := "VTD ERROR: %S [%S (%S)]"
		end

end