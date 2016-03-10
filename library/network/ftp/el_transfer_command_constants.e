note
	description: "Summary description for {EL_TRANSFER_COMMAND_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_TRANSFER_COMMAND_CONSTANTS

feature {NONE} -- Constants for FTP

	Ftp_quit: STRING = "QUIT"

	Ftp_print_working_directory: STRING = "PWD"

	Ftp_change_working_directory: STRING = "CWD"

	Ftp_make_directory: STRING = "MKD"
		-- This command (make directory) causes a directory to be created.
		-- The name of the directory to be created is indicated in the parameters.
end
