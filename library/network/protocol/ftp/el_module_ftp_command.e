note
	description: "Summary description for {EL_MODULE_FTP_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_MODULE_FTP_COMMAND

inherit
	EL_MODULE

feature {NONE} -- Constants

	Ftp_command: EL_FTP_COMMAND_ROUTINES
		once
			create Result
		end

end