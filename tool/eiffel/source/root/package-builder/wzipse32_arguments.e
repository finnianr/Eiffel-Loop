note
	description: "Arguments for WinZip self-extracting exe `wzipse32' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	WZIPSE32_ARGUMENTS

feature -- Arguments

	install_command: ZSTRING

	language_option: STRING
		-- '-lg' or '-le'

	package_ico: FILE_PATH

	text_dialog_message: ZSTRING

	text_install: ZSTRING

	title: ZSTRING

	zip_archive_path: FILE_PATH

end