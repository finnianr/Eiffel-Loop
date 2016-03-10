note
	description: "Summary description for {EIFFEL_SOURCE_TREE_CLASS_RENAME_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EIFFEL_SOURCE_TREE_CLASS_RENAME_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [EIFFEL_CLASS_RENAMER_COMMAND]
		redefine
			Option_name, Installer
		end

create
	make

feature -- Testing

	test_run
			--
		do
--			Test.do_file_tree_test ("Eiffel", agent test_source_manifest_class_renamer, 1485581754)
			Test.do_file_tree_test ("Eiffel", agent test_drag_and_drop, 632591952)
		end

	test_source_manifest_class_renamer (a_sources_path: EL_DIR_PATH)
			--
		do
			create command.make (a_sources_path + "sources-manifest.pyx" , "FILE_NAME", "EL_FILE_PATH")
			normal_run
		end

	test_drag_and_drop (a_sources_path: EL_DIR_PATH)
			--
		do
			create command.make (a_sources_path + "sources-manifest.pyx" , "", "")
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_manifest_path: EL_FILE_PATH; old_class_name, new_class_name: STRING]
		do
			create Result
			Result.source_manifest_path := ""
			Result.old_class_name := ""
			Result.new_class_name := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("sources", "Path to sources manifest file")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "class_rename"

	Description: STRING = "Rename classes defined by a source manifest file"

	Installer: EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER
		once
			create Result.make ("Eiffel Loop/Development/Rename a class")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_SOURCE_TREE_CLASS_RENAME_APP}, "*"],
				[{EIFFEL_SOURCE_MANIFEST}, "*"],
				[{EIFFEL_CLASS_RENAMER_COMMAND}, "*"],
--				[{EIFFEL_CLASS_RENAMER}, "*"],
				[{EL_TEST_ROUTINES}, "*"]
			>>
		end

end
