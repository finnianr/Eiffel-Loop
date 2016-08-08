note
	description: "Summary description for {EIFFEL_SOURCE_TREE_CLASS_RENAME_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-04 10:38:16 GMT (Thursday 4th August 2016)"
	revision: "2"

class
	EIFFEL_SOURCE_TREE_CLASS_RENAME_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [EIFFEL_CLASS_RENAMER_COMMAND]
		redefine
			Option_name, Installer
		end

create
	make

feature -- Testing

	test_run
			--
		do
			-- 4 Aug 2016
			Test.do_file_tree_test ("Eiffel/latin1-sources", agent test_source_manifest_class_renamer, 3285795821)

--			Test.do_file_tree_test ("Eiffel", agent test_drag_and_drop, 632591952)
		end

	test_source_manifest_class_renamer (a_sources_path: EL_DIR_PATH)
			--
		do
			create command.make (a_sources_path + "manifest.pyx" , "FILE_NAME", "EL_FILE_PATH")
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
				required_existing_path_argument ("sources", "Path to sources manifest file"),
				optional_argument ("old", "Old class name"),
				optional_argument ("new", "New class name")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "class_rename"

	Description: STRING = "Rename classes defined by a source manifest file"

	Installer: EL_APPLICATION_INSTALLER_I
		once
			Result := new_context_menu_installer ("Eiffel Loop/Development/Rename a class")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_SOURCE_TREE_CLASS_RENAME_APP}, All_routines],
				[{EIFFEL_SOURCE_MANIFEST}, All_routines],
				[{EIFFEL_CLASS_RENAMER_COMMAND}, All_routines]
			>>
		end

end
