note
	description: "Memory benchmark table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-01 18:38:27 GMT (Monday 1st June 2020)"
	revision: "6"

class
	MEMORY_BENCHMARK_TABLE

inherit
	BENCHMARK_TABLE

create
	make

feature {NONE} -- Implementation

	append_to_row (row: like Html_row; index: INTEGER)
		local
			string_32_test, zstring_test: like Type_benchmark.memory_tests.item
			zstring_bytes, string_32_bytes: INTEGER
		do
			string_32_test := benchmark.string_32.memory_tests [index]
			zstring_test := benchmark.zstring.memory_tests [index]

			row.append (Html.table_data (zstring_test.description))
			row.append (Html.table_data (XML.escaped (zstring_test.input_format)))

			zstring_bytes := zstring_test.storage_size; string_32_bytes := string_32_test.storage_size
			row.append (Html.table_data (comparative_bytes (zstring_bytes, string_32_bytes)))
			row.append (Html.table_data (comparative_bytes (string_32_bytes, string_32_bytes)))
		end

	test_count: INTEGER
		do
			Result := benchmark.zstring.memory_tests.count
		end

	test_result (a_benchmark: STRING_BENCHMARK; index: INTEGER): DOUBLE
		do
			Result := a_benchmark.memory_tests.i_th (index).storage_size
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
