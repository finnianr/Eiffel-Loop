note
	description: "Subject list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	SUBJECT_LIST

inherit
	EL_KEY_SORTABLE_ARRAYED_MAP_LIST [INTEGER, ZSTRING]
		rename
			extend as extend_list,
			has as has_item,
			item_value as line_item,
			last_value as last_line,
			first_value as first_line,
			value_list as line_list
		export
			{NONE} all
			{ANY} last, wipe_out, is_empty, last_line
		redefine
			make
		end

	EL_MODULE_CRC_32
		undefine
			is_equal, copy
		end

	EL_MODULE_LIO
		undefine
			is_equal, copy
		end
create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create line_set.make_equal (n)
			create decoder.make
		end

feature -- Basic operations

	save_if_different (file_path: EL_FILE_PATH)
		local
			sorted_lines: LIST [ZSTRING]; file_out: EL_PLAIN_TEXT_FILE
		do
			sort (True)
			sorted_lines := line_list
			if not Crc_32.same_as_utf_8_file (sorted_lines, file_path) then
				create file_out.make_open_write (file_path)
				file_out.enable_bom
				file_out.put_lines (sorted_lines)
				file_out.close
				lio.put_path_field ("Created new", file_path)
				lio.put_new_line
			end
		end

feature -- Element change

	extend (encoded_line: ZSTRING)
		local
			order_number, line: ZSTRING; pos_dot: INTEGER
			number: INTEGER
		do
			decoder.set_line (encoded_line)
			line := decoder.decoded_line

			number := count + 1
			pos_dot := line.index_of ('.', 1)
			if pos_dot > 0 then
				order_number := line.substring (1,  pos_dot - 1)
				if order_number.is_integer then
					line.remove_head (pos_dot)
					number := order_number.to_integer
				end
			end
			extend_list (number, line)
			line_set.put (line)
		end

feature -- Status query

	has (line: ZSTRING): BOOLEAN
		do
			Result := line_set.has (line)
		end

feature {NONE} -- Internal attributes

	line_set: EL_HASH_SET [ZSTRING]

	decoder: SUBJECT_LINE_DECODER

end
