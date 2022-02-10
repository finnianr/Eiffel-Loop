note
	description: "Causes the search directory to appear at start of list to match Unix"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 17:48:03 GMT (Thursday 10th February 2022)"
	revision: "1"

class
	EL_WINDOWS_DIR_PATH_LINE_SOURCE

inherit
	EL_WINDOWS_FILE_PATH_LINE_SOURCE
		redefine
			make, forth, start
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (find: EL_FIND_COMMAND_I; a_file_path: FILE_PATH)
		do
			if find.min_depth = 0 then
				if find.max_depth > 1 then
					if find.dir_path.is_absolute then
						first_dir_path := find.dir_path
					else
						first_dir_path := Directory.current_working #+ find.dir_path
					end
				else
					create first_dir_path
				end
			else
				normal_start := True
				create first_dir_path
			end
			Precursor (find, a_file_path)
		end

feature -- Cursor movement

	forth
		-- Move to next position
		do
			if not normal_start then
				normal_start := True
				start
			else
				Precursor
			end
		end

	start
		-- Move to first position if any.
		do
			if normal_start then
				Precursor
			else
				item := first_dir_path
				adjust_item
				count := 1; index := 1
			end
		end

feature {NONE} -- Internal attributes

	first_dir_path: DIR_PATH

	normal_start: BOOLEAN

end