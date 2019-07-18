note
	description: "Module ftp command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:54:38 GMT (Monday 1st July 2019)"
	revision: "6"

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
