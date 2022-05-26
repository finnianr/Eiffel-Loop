note
	description: "Command line interface to [$source SLIDE_SHOW_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-26 9:11:48 GMT (Thursday 26th May 2022)"
	revision: "1"

class
	SLIDE_SHOW_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [SLIDE_SHOW_COMMAND]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("config", "Pyxis configuration path", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, SLIDE_SHOW_WINDOW]
		do
			create Result.make
		end

end