note
	description: "Arguments for Windows `signtool' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	SIGN_TOOL_ARGUMENTS

feature {NONE} -- Arguments

	exe_path: FILE_PATH

	pass_phrase: STRING

	signing_certificate_path: FILE_PATH

	signtool_dir: DIR_PATH

	time_stamp_url: STRING

end
