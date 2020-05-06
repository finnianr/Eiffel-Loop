note
	description: "[
		Command line interface to [$source NOTE_EDITOR_COMMAND]
		
		This command edits the note fields of all classes defined by a source tree manifest argument
		by filling in default values for license fields listed in supplied `license' argument.
		If the modification date/time has changed, it fills in the note-fields.
		If changed, it sets the date note-field to be same as the time stamp and increments the
		revision number note-field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-06 10:29:58 GMT (Wednesday 6th May 2020)"
	revision: "20"

class
	NOTE_EDITOR_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [NOTE_EDITOR_COMMAND]
		rename
			extra_log_filter as no_log_filter
		redefine
			Option_name
		end

	EL_INSTALLABLE_SUB_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
		end

feature -- Basic operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "e" >>)
			Test.do_file_tree_test ("latin1-sources", agent test_edit, 3427892308)
			Test.do_file_tree_test ("latin1-sources", agent test_license_change, 3309637608)
		end

feature -- Test

	test_edit (dir_path: EL_DIR_PATH)
			--
		do
			create command.make (dir_path + "note-test-manifest.pyx", License_notes_path)
			normal_run
		end

	test_license_change (dir_path: EL_DIR_PATH)
			--
		do
			create command.make (dir_path + "hexagram-manifest.pyx", dir_path + "hexagram-license.pyx")
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				valid_required_argument ("license", "Path to license notes file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "")
		end

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "edit_notes"
		end

	Description: STRING = "[
		Edit the note fields of all classes defined by the source tree manifest argument.
		If the modification date/time has changed, fill in the note fields.
		If changed, sets the date field to be same as time stamp and increments
		revision number.
	]"

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/Development/Set note field defaults")
		end

	License_notes_path: EL_FILE_PATH
		once
			Result := "$EIFFEL_LOOP/license.pyx"
			Result.expand
		end

end
