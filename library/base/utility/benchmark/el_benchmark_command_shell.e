note
	description: "Summary description for {EL_BENCHMARK_COMMAND_SHELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:17:06 GMT (Sunday 21st May 2017)"
	revision: "3"

deferred class
	EL_BENCHMARK_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_COMMAND
		export
			{ANY} make_shell
		end

	EL_BENCHMARK_ROUTINES

	MEMORY
		export
			{NONE} all
		end

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make (a_number_of_runs: like number_of_runs)
		do
			make_shell
			number_of_runs := a_number_of_runs
		end

feature {NONE} -- Implementation

	average_execution (action: ROUTINE): DOUBLE
		local
			timer: EL_EXECUTION_TIMER; i: INTEGER
		do
			create timer.make
			full_collect
			from i := 1 until i > number_of_runs loop
				action.apply
				full_collect
				i := i + 1
			end
			timer.stop
			Result := timer.elapsed_millisecs / number_of_runs
		end

	compare_benchmarks (actions: like Type_actions)
		local
			times: HASH_TABLE [DOUBLE, STRING]; fastest, l_padding: STRING; label: ZSTRING
			fastest_time, execution_time, argument_a: DOUBLE
			description_width: INTEGER
		do
			create times.make_equal (actions.count)
			label := "Executing %S times"
			across actions as action loop
				lio.put_labeled_string (label #$ [number_of_runs] , action.key)
				lio.put_new_line
				if action.key.count > description_width then
					description_width := action.key.count
				end
				execution_time := average_execution (action.item)
				times [action.key] := execution_time
				if action.cursor_index = 1 then
					fastest_time := execution_time
					fastest := action.key
				elseif execution_time < fastest_time then
					fastest_time := execution_time
					fastest := action.key
				end
			end
			lio.put_new_line
			lio.put_line ("Average Execution Times")
			across actions as action loop
				if action.key ~ fastest then
					argument_a := fastest_time
				else
					argument_a := times [action.key]
				end
				create l_padding.make_filled (' ', description_width - action.key.count + 1)
				lio.put_labeled_string (action.key + l_padding, comparative_millisecs_string (argument_a, fastest_time))
				lio.put_new_line
			end
		end

feature {NONE} -- Internal attributes

	number_of_runs: INTEGER

feature {NONE} -- Type definitions

	Type_actions: EL_HASH_TABLE [ROUTINE, STRING]
		require
			never_called: False
		once
		end

end
