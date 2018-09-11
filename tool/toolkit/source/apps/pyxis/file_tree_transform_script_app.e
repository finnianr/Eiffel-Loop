note
	description: "File tree transform script app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-11 11:00:33 GMT (Tuesday 11th September 2018)"
	revision: "1"

class
	FILE_TREE_TRANSFORM_SCRIPT_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [FILE_TREE_TRANSFORMER_SCRIPT]
		redefine
			initialize, Option_name
		end

feature {NONE} -- Initialization

	initialize
		do
			Console.show ({FILE_TREE_TRANSFORMER_SCRIPT})
			Precursor
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("script", "Path to Pyxis transform script", << file_must_exist >>)
			>>
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "transform_tree"

	Description: STRING = "Transforms a tree of files using command parameters in a Pyxis script"

end
