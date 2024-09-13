note
	description: "[
		Adjust the path items to be either absolute or relative so as to match output of Unix find
		command.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 15:50:13 GMT (Friday 13th September 2024)"
	revision: "3"

class
	EL_WINDOWS_FILE_PATH_LINE_SOURCE

inherit
	EL_PLAIN_TEXT_LINE_SOURCE
		rename
			make as make_line_source
		redefine
			forth, update_item
		end

	EL_SHARED_ENCODINGS

	EL_MODULE_DIRECTORY

create
	make, make_default

feature {NONE} -- Initialization

	make (find: EL_FIND_COMMAND_I; a_file_path: FILE_PATH)
		do
			dir_path_occurrences := find.dir_path.step_count - 1
			if not find.dir_path.is_absolute then
				start_index := Directory.working.count + 2
			end
			max_depth := find.max_depth; min_depth := find.min_depth
			dir_path_string := find.dir_path
			dir_path_string.append_character ('\')
			make_encoded (Encodings.Console, a_file_path)
		end

feature -- Cursor movement

	forth
		-- Move to next position
		do
			if max_depth > 1 then
				from Precursor until after or else (min_depth <= depth and then depth <= max_depth) loop
					Precursor
				end
			else
				Precursor
			end
		end

feature {NONE} -- Implementation

	adjust_item
		local
			line: ZSTRING
		do
			if max_depth > 1 then
				line := shared_item
				if start_index.to_boolean then
--						Change absolute paths to be relative to current working directory for Linux compatibility
					if start_index > line.count then
						line.wipe_out
					else
						line.keep_tail (line.count - start_index + 1)
					end
					line.trim
				end
			else
				shared_item.prepend (dir_path_string)
				shared_item.prune_all_trailing ('\')
			end
		end

	depth: INTEGER
		do
			Result := shared_item.occurrences ('\') - dir_path_occurrences
		end

	update_item
		do
			Precursor
			adjust_item
		end

feature {NONE} -- Internal attributes

	start_index: INTEGER

	dir_path_occurrences: INTEGER

	dir_path_string: ZSTRING

	max_depth: INTEGER

	min_depth: INTEGER
end