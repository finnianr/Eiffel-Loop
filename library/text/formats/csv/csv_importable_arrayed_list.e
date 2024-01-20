note
	description: "[
		Arrayed list of reflectively settable objects that can be imported from from a
		Comma Separated Value (CSV) file. The first line must contain field names that match
		the settable fields of type G.
	]"
	tests: "Class ${COMMA_SEPARATED_IMPORT_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "15"

class
	CSV_IMPORTABLE_ARRAYED_LIST [G -> EL_REFLECTIVELY_SETTABLE create make_default end]

inherit
	EL_ARRAYED_LIST [G]

create
	make, make_filled, make_from_array, make_empty, make_from_sub_list

feature -- Element change

	import_csv_latin_1 (file_path: FILE_PATH)
		do
			import (file_path, False)
		end

	import_csv_utf_8 (file_path: FILE_PATH)
		do
			import (file_path, True)
		end

feature {NONE} -- Implementation

	import (file_path: FILE_PATH; is_utf_8: BOOLEAN)
			--
		local
			file: PLAIN_TEXT_FILE; line: STRING; new_item: G; parser: CSV_LINE_PARSER
			sum_line_count, first_line_count: INTEGER
			average_line_count: DOUBLE
		do
			if is_utf_8 then
				create {CSV_UTF_8_LINE_PARSER} parser.make
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
					if parser.count > 1 then
						create new_item.make_default
						parser.set_object (new_item)
						sum_line_count := sum_line_count + line.count
						extend (new_item)
						if full and parser.count > 5 then
							average_line_count := sum_line_count / (parser.count - 1)
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