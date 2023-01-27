note
	description: "[
		Command to edit the note fields of all classes defined by the source tree manifest argument
		by filling in default values for license fields list in supplied `license_notes_path' argument.
		If the modification date/time has changed, it fills in the note-fields.
		If changed, it sets the date note-field to be same as the time stamp and increments the
		revision number note-field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-27 14:32:22 GMT (Friday 27th January 2023)"
	revision: "26"

class
	NOTE_EDITOR_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		redefine
			execute, iterate_files
		end

	EDIT_MANAGER

create
	make

feature {EL_APPLICATION} -- Initialization

	make (source_manifest_path: FILE_PATH; cpu_percentage: INTEGER)
		require
			source_manifest_exists: source_manifest_path.exists
		do
			create operations_list.make_from (agent new_operations_list)
			create distributer.make (cpu_percentage)
			create editor_pool.make (8, agent new_editor)
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
			operations_list.call (agent {like new_operations_list}.wipe_out)

			if manifest.notes.is_empty then
				lio.put_labeled_string ("ERROR", "No note fields specified")
				lio.put_new_line
			else
				Precursor
				if attached operations_list.locked as list then
					from list.start until list.after loop
						lio.put_labeled_string (list.item_key, list.item_value)
						lio.put_new_line
						list.forth
					end
					operations_list.unlock
				end
			end
		end

feature -- Element change

	report (name: STRING; a_description: ZSTRING)
		do
			operations_list.call (agent {like new_operations_list}.extend (name, a_description))
		end

feature {NONE} -- Implementation

	iterate_files (file_list: ITERABLE [FILE_PATH])
		local
			l_editor: NOTE_EDITOR
		do
			across manifest.source_tree_list as tree loop
				if manifest.notes_table.has_key (tree.item.dir_path) then
					across tree.item.path_list as list loop
						l_editor := editor_pool.borrowed_item
						l_editor.set_default_values (manifest.notes_table.found_item)
						l_editor.set_file_path (list.item)

						distributer.wait_apply (agent l_editor.edit)
					end
					distributer.do_with_completed (agent on_edited)
				end
			end
			distributer.do_final
			distributer.do_with_completed (agent on_edited)
		end

	on_edited (a_editor: NOTE_EDITOR)
		do
			editor_pool.recycle (a_editor)
			Track.progress_listener.notify_tick
		end

	new_editor: NOTE_EDITOR
		do
			create Result.make (manifest.notes, Current)
		end

	new_operations_list: EL_ARRAYED_MAP_LIST [STRING, ZSTRING]
		do
			create Result.make (100)
		end

feature {NONE} -- Internal attributes

	distributer: EL_PROCEDURE_DISTRIBUTER [NOTE_EDITOR]

	editor_pool: EL_AGENT_FACTORY_POOL [NOTE_EDITOR]

	operations_list: EL_MUTEX_REFERENCE [like new_operations_list]

end