note
	description: "Summary description for {EL_BENCHMARK_ROUTINE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-18 9:39:18 GMT (Friday 18th May 2018)"
	revision: "1"

class
	EL_BENCHMARK_ROUTINE_TABLE

inherit
	EL_STRING_HASH_TABLE [ROUTINE, STRING]

	EL_BENCHMARK_ROUTINES
		undefine
			is_equal, copy, default_create
		end

create
	make

feature -- Basic operations

	put_comparison (lio: EL_LOGGABLE; application_count: INTEGER)
		local
			times: HASH_TABLE [DOUBLE, STRING]; fastest, l_padding: STRING
			fastest_time, execution_time, argument_a: DOUBLE
			description_width, i: INTEGER
		do
			create times.make_equal (count)
			from start until after loop
				lio.put_labeled_substitution ("Getting average time", "%S (of %S runs)" , [key_for_iteration, application_count])
				lio.put_new_line
				if key_for_iteration.count > description_width then
					description_width := key_for_iteration.count
				end
				execution_time := average_execution (item_for_iteration, application_count)
				times [key_for_iteration] := execution_time
				i := i + 1
				if i = 1 then
					fastest_time := execution_time
					fastest := key_for_iteration
				elseif execution_time < fastest_time then
					fastest_time := execution_time
					fastest := key_for_iteration
				end
				forth
			end
			lio.put_new_line
			lio.put_line ("Average Execution Times")
			from start until after loop
				if key_for_iteration ~ fastest then
					argument_a := fastest_time
				else
					argument_a := times [key_for_iteration]
				end
				create l_padding.make_filled (' ', description_width - key_for_iteration.count + 1)
				lio.put_labeled_string (key_for_iteration + l_padding, comparative_millisecs_string (argument_a, fastest_time))
				lio.put_new_line
				forth
			end
		end

end
