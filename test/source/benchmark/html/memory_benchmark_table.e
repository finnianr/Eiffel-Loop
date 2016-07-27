note
	description: "Summary description for {MEMORY_BENCHMARK_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-17 12:47:58 GMT (Thursday 17th March 2016)"
	revision: "7"

class
	MEMORY_BENCHMARK_TABLE

inherit
	BENCHMARK_TABLE

create
	make

feature {NONE} -- Implementation

	set_data_rows
		local
			string_32_test: like Type_benchmark.memory_tests.item
			zstring_bytes, string_32_bytes: INTEGER
		do
			benchmark.zstring.do_memory_tests
			benchmark.string_32.do_memory_tests

			across benchmark.zstring.memory_tests as zstring_test loop
				string_32_test := benchmark.string_32.memory_tests [zstring_test.cursor_index]
				Html_row.wipe_out
				Html_row.append (Html.table_data (zstring_test.item.description))
				Html_row.append (Html.table_data (XML.escaped (zstring_test.item.input_format)))

				zstring_bytes := zstring_test.item.storage_size; string_32_bytes := string_32_test.storage_size
				Html_row.append (Html.table_data (comparative_bytes (zstring_bytes, string_32_bytes)))
				Html_row.append (Html.table_data (comparative_bytes (string_32_bytes, string_32_bytes)))

				data_rows.extend (Html_row.twin)
			end
		end

	comparative_bytes (a, b: INTEGER): STRING
		do
			if a = b then
				Result := a.out + " bytes"
			else
				Result := relative_percentage_string (a, b)
			end
		end

feature {NONE} -- Constants

	Column_title: STRING = "Concatenated lines"

end