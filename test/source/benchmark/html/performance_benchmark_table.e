note
	description: "Performance benchmark table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	PERFORMANCE_BENCHMARK_TABLE

inherit
	BENCHMARK_TABLE
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create sorted_data_rows.make (23)
		end

feature {NONE} -- Implementation

	set_data_rows
		local
			string_32_test: like Type_benchmark.performance_tests.item
			l_sorted_data_rows: ARRAY [like sorted_data_rows.item]
			sorter: DS_ARRAY_QUICK_SORTER [like sorted_data_rows.item]
			zstring_time, string_32_time: DOUBLE
		do
			benchmark.zstring.do_performance_tests
			benchmark.string_32.do_performance_tests

			across benchmark.zstring.performance_tests as zstring_test loop
				string_32_test := benchmark.string_32.performance_tests [zstring_test.cursor_index]
				Html_row.wipe_out
				Html_row.append (Html.table_data (zstring_test.item.routines))
				Html_row.append (Html.table_data (XML.escaped (zstring_test.item.input_format)))

				zstring_time := zstring_test.item.average_time; string_32_time := string_32_test.average_time

				Html_row.append (Html.table_data (comparative_millisecs_string (zstring_time, string_32_time)))
				Html_row.append (Html.table_data (comparative_millisecs_string (string_32_time, string_32_time)))

				sorted_data_rows.extend ([relative_percentage (zstring_time, string_32_time), Html_row.twin])
			end

			l_sorted_data_rows := sorted_data_rows.to_array
			create sorter.make (performance_comparator)
			sorter.sort (l_sorted_data_rows)

			across l_sorted_data_rows as row loop
				data_rows.extend (row.item.html)
			end
		end

	is_less_than (a, b: like sorted_data_rows.item): BOOLEAN
		do
			Result := a.percent < b.percent
		end

	performance_comparator: KL_AGENT_COMPARATOR [like sorted_data_rows.item]
		do
			create Result.make (agent is_less_than)
		end

	sorted_data_rows: ARRAYED_LIST [TUPLE [percent: INTEGER; html: ZSTRING]]

feature {NONE} -- Constants

	Column_title: STRING = "String routines"

end