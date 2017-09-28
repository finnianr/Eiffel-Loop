note
	description: "Summary description for {SUBJECT_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-01 17:53:31 GMT (Friday 1st September 2017)"
	revision: "1"

class
	SUBJECT_LIST

inherit
	EL_ARRAYED_LIST [TUPLE [index: INTEGER; line: ZSTRING]]
		rename
			extend as extend_list,
			has as has_item
		export
			{NONE} all
			{ANY} last, wipe_out, is_empty
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
			sorted_lines: EL_ZSTRING_LIST; file_out: EL_PLAIN_TEXT_FILE
		do
			sort
			create sorted_lines.make (count)
			across Current as subject loop
				sorted_lines.extend (subject.item.line)
			end
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
			extend_list ([number, line])
			line_set.put (line)
		end

feature -- Status query

	has (line: ZSTRING): BOOLEAN
		do
			Result := line_set.has (line)
		end

feature {NONE} -- Implementation: Routines

	less_than (u, v: like item): BOOLEAN
			-- do nothing comparator
		do
			Result := u.index < v.index
		end

	new_index_comparator: AGENT_EQUALITY_TESTER [like item]
		do
			create Result.make (agent less_than)
		end

	sort
		local
			quick: QUICK_SORTER [like item]
		do
			create quick.make (new_index_comparator)
			quick.sort (Current)
		end

feature {NONE} -- Internal attributes

	line_set: EL_HASH_SET [ZSTRING]

	decoder: SUBJECT_LINE_DECODER

end
