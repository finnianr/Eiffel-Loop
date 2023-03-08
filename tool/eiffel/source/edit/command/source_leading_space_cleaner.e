note
	description: "Cleans up spaces at start of source code lines that should not be there"
	notes: "[
		The bad spacing was perhaps caused by using the Ctrl-K command to comment out a section
		during code editing
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-08 18:19:40 GMT (Wednesday 8th March 2023)"
	revision: "1"

class
	SOURCE_LEADING_SPACE_CLEANER

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			execute, make_default
		end

	EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create editor.make_empty
			create edited_list.make_empty
		end

feature -- Access

	edited_list: EL_FILE_PATH_LIST

	Description: STRING = "Cleans up spaces at start of source code lines that should not be there"

feature -- Basic operations

	execute
		do
			Precursor
			if edited_list.is_empty then
				lio.put_line ("All files are clean")
			else
				lio.put_substitution ("Cleaned %S files", edited_list.count)
				lio.put_new_line
				across edited_list as list loop
					lio.put_labeled_string (list.cursor_index.out, list.item.to_string)
					lio.put_new_line
				end
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			source_text: STRING
		do
			editor.set_source_text (File.plain_text (source_path))

			if editor.leading_space_count > 0 then
				edited_list.extend (source_path)
				editor.replace_spaces
				File.write_text (source_path, editor.source_text)
			end
		end

feature {NONE} -- Internal attributes

	editor: CLASS_LEADING_SPACE_EDITOR

end