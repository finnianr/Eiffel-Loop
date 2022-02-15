note
	description: "Class renaming command for set of classes defined by source manifest"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 15:19:42 GMT (Tuesday 15th February 2022)"
	revision: "22"

class
	CLASS_RENAMING_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		rename
			make as make_command
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE

create
	make

feature {EL_APPLICATION} -- Initialization

	make (source_manifest_path: FILE_PATH; a_old_name, a_new_name: STRING)
		require
			old_name_not_empty: not a_old_name.is_empty
			new_name_not_empty: not a_new_name.is_empty
		do
			old_name := a_old_name; new_name := a_new_name
			make_command (source_manifest_path)
		end

feature -- Constants

	Description: STRING = "Rename classes defined by a source manifest file"

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			line: STRING; l_file: PLAIN_TEXT_FILE
		do
			if attached File.plain_text_lines (source_path) as source_lines
				and then source_lines.target.has_substring (old_name)
				and then across source_lines as list some has_old_name_identifier (list.item) end
			then
				-- Check if `source_path' is class definition file
				if source_path.base_matches (old_name, True) then
					File_system.remove_path (source_path)
					source_path.set_base (new_name.as_lower + Eiffel_extention)
				end
				create l_file.make_open_write (source_path)
				across source_lines as list loop
					line := list.item
					if line.has_substring (old_name) then
						put_substituted (l_file, line)
					else
						l_file.put_string (line)
					end
					l_file.put_new_line
				end
				l_file.close
			end
		end

	has_old_name_identifier (line: STRING): BOOLEAN
		local
			intervals: EL_OCCURRENCE_INTERVALS [STRING]
		do
			if line.has_substring (old_name) then
				create intervals.make_by_string (line, old_name)

				from intervals.start until Result or else intervals.after loop
					if is_whole_identifier (line, intervals.item_lower, intervals.item_upper) then
						Result := True
					else
						intervals.forth
					end
				end
			end
		end

	is_whole_identifier (line: STRING; lower, upper: INTEGER): BOOLEAN
		local
			c: CHARACTER
		do
			Result := True
			if upper + 1 <= line.count then
				c := line [upper + 1]
				Result := not (c.is_alpha_numeric or c = '_')
			end
			if Result and then lower - 1 >= 1 then
				c := line [lower - 1]
				Result := not (c.is_alpha_numeric or c = '_')
			end
		end

	put_substituted (a_file: PLAIN_TEXT_FILE; line: STRING)
		local
			name_split: EL_SPLIT_STRING_8_LIST
			lower, upper: INTEGER
		do
			create name_split.make_by_string (line, old_name)
			from name_split.start until name_split.after loop
				a_file.put_string (name_split.item)
				name_split.forth
				if not name_split.after then
					lower := name_split.i_th_upper (name_split.index - 1) + 1
					upper := name_split.item_start_index - 1
					if is_whole_identifier (line, lower, upper) then
						a_file.put_string (new_name)
					else
						a_file.put_string (old_name)
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	new_name: STRING

	old_name: STRING

feature {NONE} -- Constants

	Eiffel_extention: STRING = ".e"

end