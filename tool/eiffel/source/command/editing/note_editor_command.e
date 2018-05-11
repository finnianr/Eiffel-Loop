note
	description: "[
		Command to edit the note fields of all classes defined by the source tree manifest argument
		by filling in default values for license fields list in supplied `license_notes_path' argument.
		If the modification date/time has changed, it fills in the note-fields.
		If changed, it sets the date note-field to be same as the time stamp and increments the
		revision number note-field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-22 11:35:48 GMT (Thursday 22nd February 2018)"
	revision: "5"

class
	NOTE_EDITOR_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		end

create
	make

feature {EL_SUB_APPLICATION} -- Initialization

	make (source_manifest_path, license_notes_path: EL_FILE_PATH)

		do
			log.enter_with_args ("make", << source_manifest_path >>)
			create license_notes.make_from_file (license_notes_path)
			make_editor (source_manifest_path)
			log.exit
		end

feature {NONE} -- Implementation

	new_editor: NOTE_EDITOR
		do
			create Result.make (license_notes)
		end

	license_notes: LICENSE_NOTES

end
