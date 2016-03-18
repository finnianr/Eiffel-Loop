note
	description: "Summary description for {EL_BENCHMARK_COMMAND_SHELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-18 12:50:28 GMT (Friday 18th March 2016)"
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

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make (a_number_of_runs: like number_of_runs)
		do
			make_shell
			number_of_runs := a_number_of_runs
		end

feature {NONE} -- Implementation

	average_execution (action: PROCEDURE [ANY, TUPLE]): DOUBLE
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
			times: HASH_TABLE [DOUBLE, STRING]; fastest: STRING
			minimum_time, execution_time: DOUBLE
			label: ZSTRING
		do
			create times.make_equal (actions.count)
			label := "Executing %S times"
			across actions as action loop
				log_or_io.put_labeled_string (label #$ [number_of_runs] , action.key)
				log_or_io.put_new_line
				execution_time := average_execution (action.item)
				times [action.key] := execution_time
				if action.cursor_index = 1 then
					minimum_time := execution_time
					fastest := action.key
				elseif execution_time < minimum_time then
					minimum_time := execution_time
					fastest := action.key
				end
			end
			log_or_io.put_new_line
			log_or_io.put_line ("BENCHMARKS")
			across actions as action loop
				if action.key ~ fastest then
					log_or_io.put_labeled_string (action.key, comparative_millisecs_string (minimum_time, minimum_time))
					log_or_io.put_new_line
				else
					log_or_io.put_labeled_string (action.key, comparative_millisecs_string (times [action.key], minimum_time))
					log_or_io.put_new_line
				end
			end
		end

feature {NONE} -- Internal attributes

	number_of_runs: INTEGER

feature {NONE} -- Type definitions

	Type_actions: EL_HASH_TABLE [PROCEDURE [ANY, TUPLE], STRING]
		require
			never_called: False
		once
		end

end
