note
	description: "[
		Constants base on [http://www.nsftools.com/tips/RawFTP.htm list of raw ftp commands]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-23 11:49:49 GMT (Tuesday 23rd March 2021)"
	revision: "6"

deferred class
	EL_FTP_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Numeric constants

	Default_packet_size: INTEGER
			--
		once
			Result := 2048
		end

	Max_login_attempts: INTEGER
		once
			Result := 2
		end

feature {NONE} -- Constants

	Command: TUPLE [print_working_directory, quit: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "PWD, QUIT")
		end

	Default_url: STRING = "default"

	Directory_separator: CHARACTER = '/'

	Invalid_login_error: READABLE_STRING_GENERAL
		once
			Result := "Invalid username or password"
		end

	Not_regular_file: STRING = "not a regular file"

	Template: TUPLE [change_working_directory, delete_file, make_directory, remove_directory, size: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "CWD %S, DELE %S, MKD %S, RMD %S, SIZE %S")
		end

end
