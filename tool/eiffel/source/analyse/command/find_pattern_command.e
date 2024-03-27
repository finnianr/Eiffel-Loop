note
	description: "[
		Print source lines that match a developer defined pattern
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-27 17:20:43 GMT (Wednesday 27th March 2024)"
	revision: "1"

class
	FIND_PATTERN_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			execute, make_default
		end

create
	make, make_default, default_create

feature -- Initialization

	make_default
		do
			Precursor
			create match_table.make (20)
		end

feature -- Access

	Description: STRING = "[
		Print source lines that match a developer defined pattern
	]"

feature -- Basic operations

	execute
		do
			Precursor
			across match_table as table loop
				lio.put_labeled_string ("Source", table.key)
				lio.put_new_line
				across table.item as list loop
					lio.put_line (list.item)
				end
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			file: SOURCE_FILE; line: ZSTRING; start_index, end_index, right_index: INTEGER
			found: BOOLEAN
		do
			create file.make_open_read (source_path)
			if attached Dollor_split_list as split_list then
				across file.lines as list loop
					line := list.item
					split_list.fill_by_string (line, Dollor_brace, 0)
					found := False
					across split_list as split until found loop
						start_index := split.item_lower
						end_index := line.index_of ('}', start_index + 2)
						if end_index > 0 then
							right_index := line.index_of (']', start_index + 2)
							if right_index > 0 and then right_index < end_index then
								match_table.extend (source_path, line.twin)
								found := True
							end
						end
					end
				end
			end
			file.close
		end

feature {NONE} -- Internal attributes

	match_table: EL_GROUP_TABLE [ZSTRING, FILE_PATH]

feature {NONE} -- Constants

	Dollor_brace: ZSTRING
		once
			Result := "${"
		end

	Dollor_split_list: EL_OCCURRENCE_INTERVALS
		once
			create Result.make_empty
		end

end