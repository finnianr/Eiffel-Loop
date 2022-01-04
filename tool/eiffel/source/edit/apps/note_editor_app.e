note
	description: "Command line interface to [$source NOTE_EDITOR_COMMAND]"
	notes: "[
		USAGE
			
			el_eiffel -note_editor -sources <path to manifest pyx> -licence <path to license pyx>
			
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
	date: "2022-01-04 17:19:14 GMT (Tuesday 4th January 2022)"
	revision: "25"

class
	NOTE_EDITOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [NOTE_EDITOR_COMMAND]

	EL_INSTALLABLE_SUB_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
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

	License_notes_path: FILE_PATH
		once
			Result := "$EIFFEL_LOOP/license.pyx"
			Result.expand
		end

end