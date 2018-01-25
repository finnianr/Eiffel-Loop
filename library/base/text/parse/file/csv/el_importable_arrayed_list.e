note
	description: "[
		Arrayed list of reflectively settable objects that can be imported from from a
		Comma Separated Value (CSV) file. The first line must contain field names that match
		the settable fields of type G.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 9:46:17 GMT (Thursday 28th December 2017)"
	revision: "5"

class
	EL_IMPORTABLE_ARRAYED_LIST [G -> EL_SETTABLE_FROM_STRING create make_default end]

inherit
	EL_ARRAYED_LIST [G]

create
	make, make_filled, make_from_array, make_empty, make_from_sub_list

feature -- Element change

	import_csv_latin_1 (file_path: EL_FILE_PATH)
		do
			import (file_path, False)
		end

	import_csv_utf_8 (file_path: EL_FILE_PATH)
		do
			import (file_path, True)
		end

feature {NONE} -- Implementation

	import (file_path: EL_FILE_PATH; is_utf_8: BOOLEAN)
			--
		local
			file: PLAIN_TEXT_FILE; line: STRING; new_item: G
			parser: EL_COMMA_SEPARATED_LINE_PARSER; sum_line_count, first_line_count: INTEGER
			average_line_count: DOUBLE
		do
			if is_utf_8 then
				create {EL_UTF_8_COMMA_SEPARATED_LINE_PARSER} parser.make
			else
				create parser.make
			end
			create file.make_open_read (file_path)
			from until file.end_of_file loop
				file.read_line
				line := file.last_string
				line.right_adjust
				if not line.is_empty then
					parser.parse (line)
					if Parser.count > 1 then
						create new_item.make_default
						across parser.fields as field loop
							new_item.set_field (field.item.name, field.item.value)
						end
						sum_line_count := sum_line_count + line.count
						extend (new_item)
						if full and Parser.count > 5 then
							average_line_count := sum_line_count / (Parser.count - 1)
							grow (((file.count - first_line_count) / average_line_count).rounded)
						end
					else
						first_line_count := line.count
					end
				end
			end
			file.close
		end

end
