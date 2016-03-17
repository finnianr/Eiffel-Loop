note
	description: "[
		Fills in default values for indexing fields for source trees listed in a manifest
		
		
		**** REVISE THIS APPLICATION ****
		
		10th Sept 2015 This program seems to be causing corruption in UTF-8 files
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 18:36:09 GMT (Friday 4th March 2016)"
	revision: "11"

class
	EIFFEL_NOTE_EDITOR_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [EIFFEL_NOTE_EDITOR_COMMAND]
		redefine
			Option_name, Installer
		end

feature -- Testing

	test_run
			--
		do
--			Test.do_file_tree_test ("Eiffel/sources", agent test_note_edit, 3186546115)

--			Passed Jan 2016
--			Test.do_file_tree_test ("Eiffel/latin1-sources", agent test_note_edit, 2106583659)
			Test.do_file_tree_test ("Eiffel/utf8-sources", agent test_note_edit, 550929738)
		end

	test_note_edit (a_sources_path: EL_DIR_PATH)
			--
		do
			create command.make (a_sources_path + "manifest.pyx", Execution.variable_dir_path ("EIFFEL_LOOP") + "license.pyx")
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_manifest_path, license_notes_path: EL_FILE_PATH]
		do
			create Result
			Result.source_manifest_path := ""
			Result.license_notes_path := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("sources", "Path to sources manifest file"),
				required_existing_path_argument ("license", "Path to license notes file")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "edit_notes"

	Description: STRING = "[
		Edit the note fields of all classes defined by the source tree manifest argument.
		If the modification date/time has changed, fill in the note fields.
		If changed, sets the date field to be same as time stamp and increments
		revision number.
	]"

	Installer: EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER
		once
			create Result.make ("Eiffel Loop/Development/Set note field defaults")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EL_TEST_ROUTINES}, "*"],
				[{EIFFEL_NOTE_EDITOR_APP}, "*"],
				[{EIFFEL_NOTE_EDITOR_COMMAND}, "*"],
				[{EIFFEL_NOTE_EDITOR}, "-*"]
			>>
		end

end
