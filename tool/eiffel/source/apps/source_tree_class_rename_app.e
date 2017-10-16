note
	description: "Summary description for {EIFFEL_SOURCE_TREE_CLASS_RENAME_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:29:45 GMT (Sunday 15th October 2017)"
	revision: "7"

class
	SOURCE_TREE_CLASS_RENAME_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [CLASS_RENAMER_COMMAND]
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
			Test.do_file_tree_test ("latin1-sources", agent test_source_manifest_class_renamer, 3285795821)

--			Test.do_file_tree_test ("latin1-sources", agent test_drag_and_drop, 632591952)
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

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				optional_argument ("old", "Old class name"),
				optional_argument ("new", "New class name")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", "", "")
		end

feature {NONE} -- Constants

	Option_name: STRING = "class_rename"

	Description: STRING = "Rename classes defined by a source manifest file"

	Installer: EL_APPLICATION_INSTALLER_I
		once
			Result := new_context_menu_installer ("Eiffel Loop/Development/Rename a class")
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{SOURCE_TREE_CLASS_RENAME_APP}, All_routines],
				[{SOURCE_MANIFEST}, All_routines],
				[{CLASS_RENAMER_COMMAND}, All_routines]
			>>
		end

end
