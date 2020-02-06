note
	description: "Shared access to routines of class [$source EL_FTP_COMMAND_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:16:32 GMT (Thursday 6th February 2020)"
	revision: "7"

deferred class
	EL_MODULE_FTP_COMMAND

inherit
	EL_MODULE

feature {NONE} -- Constants

	Ftp_command: EL_FTP_COMMAND_ROUTINES
		once
			create Result
		end

end
