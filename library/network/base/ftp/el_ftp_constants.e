note
	description: "[
		Constants base on [http://www.nsftools.com/tips/RawFTP.htm list of raw ftp commands]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-12 16:41:45 GMT (Saturday 12th August 2023)"
	revision: "9"

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

	Default_url: STRING = "default"

	Directory_separator: CHARACTER = '/'

	Invalid_login_error: READABLE_STRING_GENERAL
		once
			Result := "Invalid username or password"
		end

	Not_regular_file: STRING = "not a regular file"

	Command: TUPLE [
		change_working_directory, delete_file, make_directory,
		print_working_directory, quit, remove_directory, size: STRING
	]
		once
			create Result
			Tuple.fill (Result, "CWD %S, DELE %S, MKD %S, PWD, QUIT, RMD %S, SIZE %S")
		end

end