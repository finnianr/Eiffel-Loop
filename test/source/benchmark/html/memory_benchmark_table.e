note
	description: "Memory benchmark table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-01 11:17:50 GMT (Monday 1st June 2020)"
	revision: "5"

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

	sorted_indices: EL_ARRAYED_LIST [INTEGER]
		do
			create Result.make (benchmark.zstring.memory_tests.count)
			Result.append (1 |..| benchmark.zstring.memory_tests.count)
			Result.order_by (agent relative_storage_size_for_index, True)
		end

	comparative_bytes (a, b: INTEGER): STRING
		do
			if a = b then
				Result := a.out + " bytes"
			else
				Result := relative_percentage_string (a, b)
			end
		end

	relative_storage_size_for_index (index: INTEGER): INTEGER
		local
			a, b: REAL
		do
			a := benchmark.zstring.memory_tests.i_th (index).storage_size
			b := benchmark.string_32.memory_tests.i_th (index).storage_size
			Result := (a / b * 100).rounded
		end

feature {NONE} -- Constants

	Column_title: STRING = "Concatenated lines"

end
