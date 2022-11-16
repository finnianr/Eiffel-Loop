note
	description: "Arguments for Windows `signtool' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	SIGN_TOOL_ARGUMENTS

feature {NONE} -- Arguments

	exe_path: FILE_PATH

	pass_phrase: STRING

	signing_certificate_path: FILE_PATH

	signtool_dir: DIR_PATH

	time_stamp_url: STRING

end