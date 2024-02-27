note
	description: "Command line interface to ${PNG_LINK_GENERATOR}"
	notes: "[
		Usage:
			el_toolkit -png_linker [-source <dir-path>]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-27 11:47:49 GMT (Tuesday 27th February 2024)"
	revision: "3"

class
	PNG_LINK_GENERATOR_APP

inherit
	EL_COMMAND_LINE_APPLICATION [PNG_LINK_GENERATOR]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("source", "PNG directory tree", << directory_must_exist >>),
				optional_argument ("link_dir", "Directory to create links", No_checks),
				optional_argument ("exclude_steps", "Excluded all steps in list: a, b, c..", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("/usr/share", "$HOME/Graphics/icon-links", "")
		end

feature {NONE} -- Constants

	Option_name: STRING = "png_linker"

end