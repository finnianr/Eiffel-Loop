note
	description: "Module ftp command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

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
