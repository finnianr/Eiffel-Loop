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
	date: "2019-01-07 18:27:00 GMT (Monday 7th January 2019)"
	revision: "3"

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
			Test.do_file_tree_test ("bkup", agent test_normal_run (?, Empty_string), 2634948959)

			Test.do_file_tree_test ("bkup", agent test_normal_run (?, "manifest-template.evol"), 1432482264)
		end

	test_normal_run (dir_path: EL_DIR_PATH; template_name: ZSTRING)
		local
			template_path, output_path: EL_FILE_PATH
			manifest: EL_FILE_MANIFEST_LIST
		do
			if template_name.is_empty then
				create template_path
			else
				template_path := dir_path + template_name
			end
			output_path := dir_path + "manifest.xml"
			across 1 |..| 2 as n loop
				create command.make (template_path, output_path, dir_path, "bkup")
				normal_run
			end
			create manifest.make_from_file (output_path)
			if template_name.is_empty then
				if manifest ~ command.manifest then
					lio.put_line ("Restored from file OK")
				else
					lio.put_line ("File restore FAILED")
				end
			end
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				optional_argument ("template", "Path to Evolicity template"),
				required_argument ("manifest", "Path to manifest file"),
				optional_argument ("dir", "Path to directory to list in manifest"),
				required_argument ("ext", "File extension")
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
