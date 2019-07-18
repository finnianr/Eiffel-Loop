note
	description: "A table for doing comparitve performance benchmarking of routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:36:45 GMT (Monday 1st July 2019)"
	revision: "4"

class
	EL_BENCHMARK_ROUTINE_TABLE

inherit
	EL_STRING_HASH_TABLE [ROUTINE, STRING]

	EL_BENCHMARK_ROUTINES
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_LIO

create
	make

feature -- Access

	execution_times (apply_count: INTEGER): EL_VALUE_SORTABLE_ARRAYED_MAP_LIST [STRING, DOUBLE]
		-- average execution times in ascending order
		local
			execution_time: DOUBLE
		do
			create Result.make (count)
			from start until after loop
				if is_lio_enabled then
					lio.put_labeled_substitution ("Getting average time", "%S (of %S runs)" , [key_for_iteration, apply_count])
					lio.put_new_line
				end
				execution_time := average_execution (item_for_iteration, apply_count) * 1000
				Result.extend (key_for_iteration, execution_time)
				forth
			end
			Result.sort (True)
		end

	max_key_width: INTEGER
		-- character width of longest key string
		do
			from start until after loop
				if key_for_iteration.count > Result then
					Result := key_for_iteration.count
				end
				forth
			end
		end

feature -- Basic operations

	put_comparison (apply_count: INTEGER)
		local
			times: like execution_times
			fastest_time: DOUBLE; description_width: INTEGER; l_padding: STRING
		do
			times := execution_times (apply_count)
			description_width := max_key_width
			fastest_time := times.first_value

			if is_lio_enabled then
				lio.put_new_line
				lio.put_line ("Average execution times (in ascending order)")
			end
			from times.start until times.after loop
				create l_padding.make_filled (' ', description_width - times.item_key.count + 1)
				lio.put_labeled_string (times.item_key + l_padding, comparative_string (times.item_value, fastest_time, "millisecs"))
				lio.put_new_line
				times.forth
			end
		end

feature {NONE} -- Constants

	Averaging_template: ZSTRING
		once
			Result := "Averaging over %S runs"
		end

end
