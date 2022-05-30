note
	description: "Command line interface to [$source SLIDE_SHOW_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-29 12:44:01 GMT (Sunday 29th May 2022)"
	revision: "2"

class
	SLIDE_SHOW_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [SLIDE_SHOW_COMMAND]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := << config_argument ("Pyxis slide_show configuration path") >>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, SLIDE_SHOW_WINDOW, SLIDE_SHOW]
		do
			create Result.make
		end

end