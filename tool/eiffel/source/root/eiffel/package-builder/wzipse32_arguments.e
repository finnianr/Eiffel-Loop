note
	description: "Arguments for WinZip self-extracting exe `wzipse32' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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