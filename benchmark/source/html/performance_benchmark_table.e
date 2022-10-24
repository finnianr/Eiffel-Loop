note
	description: "Performance benchmark table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-24 14:39:26 GMT (Monday 24th October 2022)"
	revision: "7"

class
	PERFORMANCE_BENCHMARK_TABLE

inherit
	BENCHMARK_TABLE

create
	make

feature -- Status query

	is_memory: BOOLEAN = False

feature {NONE} -- Implementation

	append_to_row (row: like Html_row; index: INTEGER)
		local
			test_32, test_z: like Type_benchmark.performance_tests.item
			absolute_result, relative_result: STRING
		do
			test_32 := benchmark.string_32.performance_tests [index]
			test_z := benchmark.zstring.performance_tests [index]

			row.append (Html.table_data (test_z.routines))
			row.append (Html.table_data (XML.escaped (test_z.input_format)))

			if relative_percentage (test_32.repetition_count, test_z.repetition_count) = 0 then
				relative_result := test_32.repetition_count.rounded.out
			else
				relative_result := relative_percentage_string (test_32.repetition_count, test_z.repetition_count)
			end
			absolute_result := test_z.repetition_count.rounded.out

			across << absolute_result, relative_result >> as string loop
				row.append (Html.table_data (string.item))
			end
		end

	test_count: INTEGER
		do
			Result := benchmark.zstring.performance_tests.count
		end

	test_result (a_benchmark: STRING_BENCHMARK [STRING_GENERAL]; index: INTEGER): DOUBLE
		do
			Result := a_benchmark.performance_tests [index].repetition_count
		end

feature {NONE} -- Constants

	Column_title: STRING = "String routines"


end