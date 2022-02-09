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
	date: "2022-02-08 16:32:52 GMT (Tuesday 8th February 2022)"
	revision: "21"

class
	NOTE_EDITOR_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		redefine
			execute, iterate_files
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

	iterate_files (file_list: ITERABLE [FILE_PATH])
		do
			across manifest.source_tree_list as tree loop
				if manifest.notes_table.has_key (tree.item.dir_path) then
					editor.set_default_values (manifest.notes_table.found_item)
					across tree.item.path_list as list loop
						do_with_file (list.item)
						Track.progress_listener.notify_tick
					end
				end
			end
		end

	new_editor: NOTE_EDITOR
		do
			create Result.make (manifest.notes, operations_list)
		end

feature {NONE} -- Internal attributes

	operations_list: like editor.operations_list

end