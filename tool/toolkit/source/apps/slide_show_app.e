note
	description: "Command line interface to [$source SLIDE_SHOW_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-03 12:14:45 GMT (Friday 3rd June 2022)"
	revision: "4"

class
	SLIDE_SHOW_APP

inherit
	EL_COMMAND_LINE_APPLICATION [EL_IMAGE_MAGICK_SLIDE_SHOW_COMMAND]
		redefine
			visible_types
		end

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

	visible_types: TUPLE -- [EL_OS_COMMAND]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

end