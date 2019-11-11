note
	description: "Id3 frame enum generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 19:41:53 GMT (Monday 11th November 2019)"
	revision: "2"

class
	ID3_FRAME_ENUM_GENERATOR

inherit
	EL_COMMAND

	EL_MODULE_LIO

create
	make

feature {EL_SUB_APPLICATION} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		do
			file_path := a_file_path
			create code_table.make_equal (255)
		end

feature -- Basic operations

	execute
		local
			file_lines: EL_PLAIN_TEXT_LINE_SOURCE
			fields: EL_ZSTRING_LIST; id3_code: ZSTRING
			map: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [ZSTRING, ZSTRING]
			source_file: EL_PLAIN_TEXT_FILE
		do
			create file_lines.make (file_path)
			across file_lines as line loop
				create fields.make_with_words (line.item)
				if fields.count >= 3 then
					id3_code := fields [2]
					fields.remove_head (2)
					code_table.put (fields.joined_words, id3_code)
				end
			end
			file_lines.close
			create source_file.make_open_write ("workarea/frame_enum.e")
			create map.make_from_table (code_table)
			map.sort (True)
			from map.start until map.after loop
				lio.put_labeled_string (map.item_key, map.item_value)
				lio.put_new_line
				source_file.put_string (Template #$ [map.item_key, map.item_value])
				source_file.put_new_line
				source_file.put_new_line
				map.forth
			end
			source_file.close
			lio.put_integer_field ("count", map.count)
			lio.put_new_line
		end

feature {NONE} -- Implementation

	code_table: EL_ZSTRING_HASH_TABLE [ZSTRING]

	file_path: EL_FILE_PATH

feature {NONE} -- Constants

	Template: ZSTRING
		once
			Result := "%T%S: NATURAL_8%N%T%T-- %S"
		end
end
