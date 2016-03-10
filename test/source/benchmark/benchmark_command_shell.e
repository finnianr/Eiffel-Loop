note
	description: "Summary description for {EL_BENCHMARK_COMMAND_SHELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:27:40 GMT (Friday 18th December 2015)"
	revision: "5"

class
	BENCHMARK_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_COMMAND
		export
			{ANY} make_shell
		end

	BENCHMARK_ROUTINES

	MEMORY
		export
			{NONE} all
		end

	EL_MODULE_LOG

create
	default_create, make

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_number_of_runs: like number_of_runs)
		do
			make_shell
			number_of_runs := a_number_of_runs
		end

feature -- Basic operations

	compare_pyxis_attribute_parsers
		local
		do
			log.enter ("compare_pyxis_attribute_parsers")

--			compare_benchmarks (["ASTRING parser", agent parser_1.parse], ["ZSTRING parser", agent parser_2.parse])
--			New one is 10% faster
			log.exit
		end

feature {NONE} -- Implementation

	compare_benchmarks (action_1, action_2: TUPLE [name: STRING; procedure: PROCEDURE [ANY, TUPLE]])
		local
			times: ARRAY [DOUBLE]
		do
			create times.make_filled (0, 1, 2)
			across << action_1, action_2 >> as action loop
				log_or_io.put_labeled_string ("Executing", action.item.name)
				log_or_io.put_new_line
				times [action.cursor_index] := average_execution (action.item.procedure)
			end
			log_or_io.put_labeled_string (action_1.name, comparative_millisecs (times [1], times [1]))
			log_or_io.put_new_line
			log_or_io.put_labeled_string (action_2.name, comparative_millisecs (times [2], times [1]))
			log_or_io.put_new_line
		end

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

feature {NONE} -- Internal attributes

	number_of_runs: INTEGER

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Compare Pyxis attribute parsers", 		agent compare_pyxis_attribute_parsers]
			>>)
		end

feature {NONE} -- Constants


end
