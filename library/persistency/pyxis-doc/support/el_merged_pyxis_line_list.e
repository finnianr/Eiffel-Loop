note
	description: "Merged pyxis line list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-21 14:04:36 GMT (Friday 21st June 2024)"
	revision: "1"

class
	EL_MERGED_PYXIS_LINE_LIST

inherit
	EL_STRING_8_LIST
		rename
			make as make_sized
		end

	EL_STRING_STATE_MACHINE [STRING]
		rename
			make as make_machine
		undefine
			copy, is_equal
		end

	EL_MODULE_FILE; EL_MODULE_LIO; EL_MODULE_PYXIS

create
	make

feature {NONE} -- Initialization

	make (path_list: EL_FILE_PATH_LIST)
		local
			markup: EL_MARKUP_ENCODING
		do
			make_sized (path_list.sum_byte_count // 60)
			across path_list as source_path loop
				markup := Pyxis.encoding (source_path.item)
				if is_lio_enabled then
					lio.put_labeled_string ("Merging " + markup.name + " file", source_path.item.base)
					lio.put_new_line
				end
				file_count := file_count + 1
				do_with_split (agent find_root_element, File.plain_text_lines (source_path.item), True)
			end
		end

feature {NONE} -- Line states

	find_root_element (line: STRING)
		do
			if line_number = 1 and then line.starts_with ({UTF_CONVERTER}.utf_8_bom_to_string_8) then
				line.remove_head (3)
			end
			line.right_adjust
			if line.count > 0 and then line [line.count] = ':' and then line [1] /= '#'
				and then not Pyxis.is_declaration (line)
			then
				if file_count = 1 then
					extend (line)
				end
				state := agent extend
			elseif file_count = 1 then
				extend (line)
			end
		end

feature {NONE} -- Internal attributes

	file_count: INTEGER

end