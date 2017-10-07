note
	description: "[
		Example program to demonstrate use of `EL_FUNCTION_DISTRIBUTER' and `EL_PROCEDURE_DISTRIBUTER'
		for distributing the work of executing agent routines over a maximum number of threads.
	]"
	instructions: "[
		 Example of command to the run the finalized build
		
			. run_test.sh -work_distributer -logging -term_count 20 -task_count 64 -delta_count 4000000 -thread_count 8
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-03 13:27:27 GMT (Tuesday 3rd October 2017)"
	revision: "4"

class
	TEST_WORK_DISTRIBUTER_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name, initialize, on_operating_system_signal
		end

	EL_DOUBLE_MATH

	DOUBLE_MATH
		rename
			log as natural_log
		end

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		local
			priority: STRING
		do
			log.enter ("initialize")
			create wave

			create count_arguments.make_equal (Variable.count)
			count_arguments [Variable.delta_count] := (10000).to_reference
			count_arguments [Variable.term_count] := (4).to_reference
			count_arguments [Variable.thread_count] := (4).to_reference
			count_arguments [Variable.task_count] := (4).to_reference
			count_arguments [Variable.repetition_count] := (1).to_reference

			across count_arguments as argument loop
				set_attribute_from_command_opt (argument.item, argument.key, "Value of " + argument.key)
				log.put_integer_field (argument.key, argument.item.item)
				log.put_new_line
			end

			create procedure_distributer.make (thread_count)
			create function_distributer.make (thread_count)

			create turbo_mode
			set_boolean_from_command_opt (turbo_mode, "turbo", "Use maximum priority threads")
			if turbo_mode.item then
				priority := "maximum"
				function_distributer.set_turbo
				procedure_distributer.set_turbo
			else
				priority := "normal"
			end
			log.put_labeled_string ("Thread priority", priority)
			log.put_new_line

			log.exit
		end

feature -- Basic operations

	run
		local
			i: INTEGER
		do
			log.enter ("run")

			do_calculation (
				"single thread integral",
				agent: DOUBLE do Result := integral (agent wave.complex_sine_wave (?, term_count), 0, 2 * Pi, delta_count) end
			)
			from i := 1 until i > repetition_count loop
				do_calculation (
					"distributed integral using class EL_FUNCTION_DISTRIBUTER",
					agent: DOUBLE do Result := test_function_distribution (agent wave.complex_sine_wave (?, term_count), 0, 2 * Pi) end
				)
				do_calculation (
					"distributed integral using class EL_PROCEDURE_DISTRIBUTER",
					agent: DOUBLE do Result := test_procedure_distribution (agent wave.complex_sine_wave (?, term_count), 0, 2 * Pi) end
				)
				i := i + 1
			end
			log.exit
		end

feature {NONE} -- Implementation

	do_calculation (a_description: STRING; calculation: FUNCTION [DOUBLE])
		do
			log.put_labeled_string ("Method", a_description)
			log.put_new_line
			log.set_timer
			log.put_line ("calculating integral (complex_sine_wave, 0, 2 * Pi)")
			calculation.apply
			log.put_double_field ("integral", calculation.last_result)
			log.put_new_line
			log.put_elapsed_time
			log.put_new_line
		end

	on_operating_system_signal
		-- on user cancelled (Ctrl-C)
		do
			procedure_distributer.do_final
			function_distributer.do_final
		end

	test_function_distribution (f: FUNCTION [DOUBLE, DOUBLE]; lower, upper: DOUBLE): DOUBLE
		-- using `EL_FUNCTION_DISTRIBUTER'
		local
			result_count: INTEGER; result_list: ARRAYED_LIST [DOUBLE]
		do
			create result_list.make (task_count)

			-- Splitting bounds into sub-bounds
			across split_bounds (lower, upper, task_count) as bound loop
				function_distributer.wait_apply (
					agent integral (f, bound.item.lower_bound, bound.item.upper_bound, (delta_count / task_count).rounded)
				)

				-- collect results
				function_distributer.collect (result_list)
			end
			log.put_line ("Waiting to complete ..")
			function_distributer.do_final
			function_distributer.collect_final (result_list)

			put_launched_count (function_distributer)
			check_result_count (result_list)

			-- Add results of all sub-bounds
			across result_list as function loop
				Result := Result + function.item
			end
		end

	test_procedure_distribution (f: FUNCTION [DOUBLE, DOUBLE]; lower, upper: DOUBLE): DOUBLE
		-- using `EL_PROCEDURE_DISTRIBUTER'
		local
			result_count: INTEGER; result_list: ARRAYED_LIST [INTEGRAL_MATH]
			l_integral: INTEGRAL_MATH
		do
			create result_list.make (task_count)

			-- Splitting bounds into sub-bounds
			across split_bounds (lower, upper, task_count) as bound loop
				create l_integral.make (f, bound.item.lower_bound, bound.item.upper_bound, (delta_count / task_count).rounded)
				procedure_distributer.wait_apply (agent l_integral.calculate)

				-- collect results
				procedure_distributer.collect (result_list)
			end
			log.put_line ("Waiting to complete ..")
			procedure_distributer.do_final
			procedure_distributer.collect_final (result_list)

			put_launched_count (procedure_distributer)
			check_result_count (result_list)

			-- Add results of all sub-bounds
			across result_list as value loop
				Result := Result + value.item.integral
			end
		end

	put_launched_count (distributer: EL_WORK_DISTRIBUTER [ROUTINE])
		do
			log.put_integer_field ("distributer.launched_count", distributer.launched_count)
			log.put_new_line
		end

	check_result_count (result_list: LIST [ANY])
		do
			if not result_list.full then
				log.put_line ("ERROR: missing result")
				log.put_integer_field ("result_list.count", result_list.count); log.put_integer_field (" task_count", task_count)
				log.put_new_line
			end
		end

	delta_count: INTEGER
		do
			Result := count_arguments [Variable.delta_count]
		end

	term_count: INTEGER
		do
			Result := count_arguments [Variable.term_count]
		end

	task_count: INTEGER
		do
			Result := count_arguments [Variable.task_count]
		end

	thread_count: INTEGER
		do
			Result := count_arguments [Variable.thread_count]
		end

	repetition_count: INTEGER
		do
			Result := count_arguments [Variable.repetition_count]
		end

feature {NONE} -- Internal attributes

	count_arguments: HASH_TABLE [INTEGER_REF, STRING]

	function_distributer: EL_FUNCTION_DISTRIBUTER [DOUBLE]

	turbo_mode: BOOLEAN_REF

	procedure_distributer: EL_PROCEDURE_DISTRIBUTER [INTEGRAL_MATH]

	wave: SINE_WAVE

feature {NONE} -- Constants

	Description: STRING = "Test distributed calculation of integrals"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{TEST_WORK_DISTRIBUTER_APP}, All_routines]
			>>
		end

	Variable: TUPLE [delta_count, term_count, task_count, thread_count, repetition_count: STRING]
		once
			Result := ["delta_count", "term_count", "task_count", "thread_count", "repetition_count"]
		end

	Option_name: STRING = "work_distributer"

end
