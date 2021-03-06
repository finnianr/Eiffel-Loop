note
	description: "Performance benchmark table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-01 18:38:27 GMT (Monday 1st June 2020)"
	revision: "6"

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

	test_count: INTEGER
		do
			Result := benchmark.zstring.performance_tests.count
		end

	test_result (a_benchmark: STRING_BENCHMARK; index: INTEGER): DOUBLE
		do
			Result := a_benchmark.performance_tests.i_th (index).average_time
		end

feature {NONE} -- Constants

	Column_title: STRING = "String routines"

end
