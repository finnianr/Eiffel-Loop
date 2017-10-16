note
	description: "[
		Fills in default values for note fields for source trees listed in a manifest
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:28:58 GMT (Sunday 15th October 2017)"
	revision: "8"

class
	NOTE_EDITOR_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [NOTE_EDITOR_COMMAND]
		redefine
			Option_name, Installer
		end

feature -- Basic operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "e" >>)
			Test.do_file_tree_test ("latin1-sources", agent test_edit, 3319767416)
		end

feature -- Test

	test_edit (dir_path: EL_DIR_PATH)
			--
		do
			create command.make (dir_path + "note-test-manifest.pyx", License_notes_path)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				valid_required_argument ("license", "Path to license notes file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", "")
		end

feature {NONE} -- Constants

	Option_name: STRING = "edit_notes"

	Description: STRING = "[
		Edit the note fields of all classes defined by the source tree manifest argument.
		If the modification date/time has changed, fill in the note fields.
		If changed, sets the date field to be same as time stamp and increments
		revision number.
	]"

	Installer: EL_APPLICATION_INSTALLER_I
		once
			Result := new_context_menu_installer ("Eiffel Loop/Development/Set note field defaults")
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{NOTE_EDITOR_APP}, All_routines],
				[{NOTE_EDITOR_COMMAND}, All_routines],
				[{NOTE_EDITOR}, All_routines]
			>>
		end

	License_notes_path: EL_FILE_PATH
		once
			Result := "$EIFFEL_LOOP/license.pyx"
			Result.expand
		end

end
