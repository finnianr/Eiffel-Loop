note
	description: "[
		Sub-application to create an XML file manifest of a target directory using either the default Evolicity template
		or an optional external Evolicity template.
		See class [$source EL_FILE_MANIFEST_COMMAND] for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 12:12:32 GMT (Thursday 13th January 2022)"
	revision: "11"

class
	FILE_MANIFEST_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EL_FILE_MANIFEST_GENERATOR]
		redefine
			Option_name
		end

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("template", "Path to Evolicity template"),
				required_argument ("manifest", "Path to manifest file"),
				optional_argument ("dir", "Path to directory to list in manifest"),
				required_argument ("ext", "File extension")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (Empty_string, Empty_string, Empty_string, "*")
		end

feature {NONE} -- Constants

	Option_name: STRING = "file_manifest"

end