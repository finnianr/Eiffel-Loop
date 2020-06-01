note
	description: "Performance benchmark table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-01 11:19:41 GMT (Monday 1st June 2020)"
	revision: "5"

class
	PERFORMANCE_BENCHMARK_TABLE

inherit
	BENCHMARK_TABLE

create
	make

feature {NONE} -- Implementation

	append_to_row (row: like Html_row; index: INTEGER)
		local
			string_32_test, zstring_test: like Type_benchmark.performance_tests.item
			zstring_time, string_32_time: DOUBLE
		do
			string_32_test := benchmark.string_32.performance_tests [index]
			zstring_test := benchmark.zstring.performance_tests [index]

			row.append (Html.table_data (zstring_test.routines))
			row.append (Html.table_data (XML.escaped (zstring_test.input_format)))

			zstring_time := zstring_test.average_time; string_32_time := string_32_test.average_time

			row.append (Html.table_data (comparative_millisecs_string (zstring_time, string_32_time)))
			row.append (Html.table_data (comparative_millisecs_string (string_32_time, string_32_time)))
		end

	relative_percentage_for_index (index: INTEGER): INTEGER
		local
			a, b: DOUBLE
		do
			a := benchmark.zstring.performance_tests.i_th (index).average_time
			b := benchmark.string_32.performance_tests.i_th (index).average_time
			Result := relative_percentage (a, b)
		end

	sorted_indices: EL_ARRAYED_LIST [INTEGER]
		do
			create Result.make (benchmark.zstring.performance_tests.count)
			Result.append (1 |..| benchmark.zstring.performance_tests.count)
			Result.order_by (agent relative_percentage_for_index, True)
		end

feature {NONE} -- Constants

	Column_title: STRING = "String routines"

end
