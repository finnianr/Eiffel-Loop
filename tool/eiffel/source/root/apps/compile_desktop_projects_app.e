note
	description: "Command line interface to command ${COMPILE_DESKTOP_PROJECTS}"
	notes: "[
		Usage:
			el_eiffel -compile_desktop_projects -location <dir-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	COMPILE_DESKTOP_PROJECTS_APP

inherit
	EL_COMMAND_LINE_APPLICATION [COMPILE_DESKTOP_PROJECTS]
		redefine
			is_valid_platform
		end

create
	make

feature -- Status query

	is_valid_platform: BOOLEAN
		do
			Result := {PLATFORM}.is_unix
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("location", "Location of desktop launchers", << directory_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (Directory.desktop.twin)
		end

end