note
	description: "VTD C callback exception routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	EL_VTD_CALLABLE_EXCEPTIONS

inherit
	EL_C_CALLABLE

create
	make

feature {NONE} -- C call backs

	frozen on_exception_basic (exception_code: INTEGER; evx_message: POINTER)
			-- Handles C exception defined in vtdNav.c

			--	void throwException2 (enum exception_code et, char *msg){
			--		exception e;
			--		e.et = et;
			--		e.subtype = BASIC_EXCEPTION;
			--		e.msg = msg;
			--		Throw e;
			--	}
		require
			evx_message_attached: is_attached (evx_message)
		local
			exception: EL_VTD_EXCEPTION
		do
			create exception.make_basic (exception_code, evx_message)
			exception.raise
		end

	frozen on_exception_full (exception_code, line_number, line_offset: INTEGER; evx_message, evx_sub_message: POINTER)
			-- Handles C exception defined in vtdNav.c

			--	void throwException(enum exception_code et, int sub_type, char* msg, char* submsg){
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
		local
			exception: EL_VTD_EXCEPTION; parse: EL_VTD_PARSE_EXCEPTION
		do
			if exception_code = 3 then
				create parse.make_full (exception_code, evx_message, evx_sub_message)
				parse.set_position (line_number, line_offset)
				exception := parse
			else
				create exception.make_full (exception_code, evx_message, evx_sub_message)
			end
			exception.raise
		end

feature {NONE} -- Implementation

	new_string (evx_message: POINTER): STRING
		do
			create Result.make_from_c (evx_message)
		end

feature {NONE} -- Constants

	Call_back_routines: ARRAY [POINTER]
		once
			Result := << $on_exception_basic, $on_exception_full >>
		end

end