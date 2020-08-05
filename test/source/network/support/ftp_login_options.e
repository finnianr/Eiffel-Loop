note
	description: "Ftp login options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-05 10:20:01 GMT (Wednesday 5th August 2020)"
	revision: "1"

class
	FTP_LOGIN_OPTIONS

inherit
	EL_APPLICATION_COMMAND_OPTIONS
		redefine
			Help_text
		end

create
	make, make_default

feature -- Access

	url: STRING

	user_home: EL_DIR_PATH

feature {NONE} -- Constants

	Help_text: STRING
		do
			Result := joined (Precursor, "[
				url:
					FTP url
				user_home:
					Site home directory
			]")
		end

end
