note
	description: "Ftp login options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "3"

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

	user_home: DIR_PATH

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
