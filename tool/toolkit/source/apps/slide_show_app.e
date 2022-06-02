note
	description: "Command line interface to [$source SLIDE_SHOW_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 15:10:49 GMT (Thursday 2nd June 2022)"
	revision: "3"

class
	SLIDE_SHOW_APP

inherit
	EL_COMMAND_LINE_APPLICATION [SLIDE_SHOW_COMMAND]

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

end