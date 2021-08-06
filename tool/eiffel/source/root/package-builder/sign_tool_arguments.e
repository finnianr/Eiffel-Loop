note
	description: "Arguments for Windows `signtool' command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-06 18:00:47 GMT (Friday 6th August 2021)"
	revision: "1"

class
	SIGN_TOOL_ARGUMENTS

feature {NONE} -- Arguments

	exe_path: EL_FILE_PATH

	pass_phrase: STRING

	signing_certificate_path: EL_FILE_PATH

	signtool_dir: EL_DIR_PATH

	time_stamp_url: STRING

end