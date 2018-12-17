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
	date: "2018-12-13 13:56:40 GMT (Thursday 13th December 2018)"
	revision: "2"

class
	FILE_MANIFEST_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [EL_FILE_MANIFEST_COMMAND]
		redefine
			Option_name
		end

	EL_ZSTRING_CONSTANTS

feature -- Test operations

	test_run
		do
			Test.do_file_tree_test ("bkup", agent test_normal_run (?, Empty_string), 1521481948)

			Test.do_file_tree_test ("bkup", agent test_normal_run (?, "manifest-template.evol"), 3387999578)
		end

	test_normal_run (dir_path: EL_DIR_PATH; template_name: ZSTRING)
		local
			template_path: EL_FILE_PATH
		do
			if template_name.is_empty then
				create template_path
			else
				template_path := dir_path + template_name
			end
			create command.make (template_path, dir_path + "manifest.xml", dir_path, "*.bkup")
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				optional_argument ("template", "Path to Evolicity template"),
				required_argument ("manifest", "Path to manifest file"),
				optional_argument ("dir", "Path to directory to list in manifest"),
				required_argument ("wildcard", "File wildcard")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make (Empty_string, Empty_string, Empty_string, "*")
		end

feature {NONE} -- Constants

	Option_name: STRING = "file_manifest"

	Description: STRING = "Generate an XML manifest of a directory for files matching a wildcard"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{FILE_MANIFEST_APP}, All_routines]
			>>
		end

end
