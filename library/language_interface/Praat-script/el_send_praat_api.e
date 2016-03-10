note
	description: "Interface to C API for sending commands to running instance of Praat.exe"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SEND_PRAAT_API

obsolete
	"[
		This class has now been superceded by a direct Eiffel wrapping of Praat
		See: EL_PRAAT_ENGINE
	]"

feature -- Basic operations

	exec_praat_command (arguments: STRING)
			-- Sends a command to a running instance of praat
		local
			c_args: ANY
			c_praat_program_name: ANY
			c_returned_ptr: POINTER
		do
			c_args := arguments.to_c
			c_praat_program_name := Praat_program_name.to_c
			c_returned_ptr := c_send_praat (Default_pointer, $c_praat_program_name, 0, $c_args)
			
			if is_attached (c_returned_ptr) then
				create last_praat_cmd_status_msg.make_from_c (c_returned_ptr)
			else
				create last_praat_cmd_status_msg.make_empty
			end
		end


feature {NONE} -- Implementation

	Praat_program_name: STRING = "Praat"

	Praat_quit_command: STRING = "Quit"
	
	last_praat_cmd_status_msg: STRING
		

feature {NONE} -- C externals
	
	c_send_praat (xwin_display_ptr, program_name: POINTER; praat_time_out: INTEGER; arguments: POINTER): POINTER
			-- Send a command to praat
			
			--| xwin_display_ptr is Unix only

			--| Windows C code example:
			--| char *sendpraat (void *display, const char *programName, long timeOut, const char *text);
			--| char message [100], *errorMessage;
			--| strcpy (message, "doAll.praat 20");
			--| errorMessage = sendpraat (NULL, "praat", 0, message);
			
		external
			"C (void *, const char *, long, const char *): EIF_POINTER| %"sendpraat.h%""
		alias
			"sendpraat"
		end
	
end


