note
	description: "Summary description for {EL_TRANSFER_COMMAND_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

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