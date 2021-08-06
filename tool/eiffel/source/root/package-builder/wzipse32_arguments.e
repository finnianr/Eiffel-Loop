note
	description: "Arguments for WinZip self-extracting exe `wzipse32' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-06 18:01:22 GMT (Friday 6th August 2021)"
	revision: "1"

class
	WZIPSE32_ARGUMENTS

feature -- Arguments

	install_command: ZSTRING

	language_option: STRING
		-- '-lg' or '-le'

	package_ico: EL_FILE_PATH

	text_dialog_message: ZSTRING

	text_install: ZSTRING

	title: ZSTRING

	zip_archive_path: EL_FILE_PATH

end