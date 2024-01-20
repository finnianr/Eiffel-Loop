note
	description: "[
		Sub-application to create an XML file manifest of a target directory using either the default
		Evolicity template or an optional external Evolicity template.
		See class ${EL_FILE_MANIFEST_GENERATOR} for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "17"

class
	FILE_MANIFEST_APP

inherit
	EL_COMMAND_LINE_APPLICATION [EL_FILE_MANIFEST_GENERATOR]
		redefine
			Option_name, visible_types
		end

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("template", "Path to Evolicity template", No_checks),
				required_argument ("manifest", "Path to manifest file", No_checks),
				optional_argument ("dir", "Path to directory to list in manifest", No_checks),
				required_argument ("ext", "File extension", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (Empty_string, Empty_string, Empty_string, "*")
		end

	visible_types: TUPLE [EL_FILE_MANIFEST_GENERATOR]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "file_manifest"

end