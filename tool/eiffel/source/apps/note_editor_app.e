note
	description: "[
		Fills in default values for note fields for source trees listed in a manifest
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:27:30 GMT (Thursday 29th June 2017)"
	revision: "6"

class
	NOTE_EDITOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [NOTE_EDITOR_COMMAND]
		redefine
			Option_name, Installer
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_manifest_path, license_notes_path: EL_FILE_PATH]
		do
			create Result
			Result.source_manifest_path := ""
			Result.license_notes_path := ""
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				valid_required_argument ("license", "Path to license notes file", << file_must_exist >>)
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

	Installer: EL_APPLICATION_INSTALLER_I
		once
			Result := new_context_menu_installer ("Eiffel Loop/Development/Set note field defaults")
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{NOTE_EDITOR_APP}, All_routines],
				[{NOTE_EDITOR_COMMAND}, All_routines]
			>>
		end

end
