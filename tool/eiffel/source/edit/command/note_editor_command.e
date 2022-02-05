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
	date: "2022-02-05 14:46:06 GMT (Saturday 5th February 2022)"
	revision: "18"

class
	NOTE_EDITOR_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		redefine
			execute
		end

create
	make

feature {EL_APPLICATION} -- Initialization

	make (source_manifest_path: FILE_PATH)
		require
			source_manifest_exists: source_manifest_path.exists
		do
			create operations_list.make (100)
			make_editor (source_manifest_path)
		end

feature -- Constants

	Description: STRING = "[
		Edit the note fields of all classes defined by the source tree manifest argument.
		If the modification date/time has changed, fill in the note fields.
		If changed, sets the date field to be same as time stamp and increments
		revision number.
	]"

feature -- Basic operations

	execute
		do
			operations_list.wipe_out

			if manifest.notes.is_empty then
				lio.put_labeled_string ("ERROR", "No note fields specified")
				lio.put_new_line
			else
				Precursor
				if attached operations_list as list then
					from list.start until list.after loop
						lio.put_labeled_string (list.item_key, list.item_value)
						lio.put_new_line
						list.forth
					end
				end
			end
		end

feature {NONE} -- Implementation

	new_editor: NOTE_EDITOR
		do
			create Result.make (manifest.notes, operations_list)
		end

feature {NONE} -- Internal attributes

	operations_list: like editor.operations_list

end