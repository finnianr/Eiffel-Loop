note
	description: "Command line interface to command [$source WET_DRY_GEOMETRY_SEPARATOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 17:13:44 GMT (Friday 14th February 2020)"
	revision: "1"

class
	WET_DRY_GEOMETRY_SEPARATOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [WET_DRY_GEOMETRY_SEPARATOR]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("model", "Path to model data in JSON format", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH})
		end

feature {NONE} -- Constants

	Description: STRING = "Split 3D model into wet and dry geometric representations"
end
