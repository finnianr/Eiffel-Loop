note
	description: "Ftp login options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

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