note
	description: "[
		Example program to demonstrate use of `[$source EL_FUNCTION_DISTRIBUTER]' and `[$source EL_PROCEDURE_DISTRIBUTER]'
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
	date: "2017-10-08 12:27:50 GMT (Sunday 8th October 2017)"
	revision: "5"

class
	TEST_WORK_DISTRIBUTER_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name, initialize
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

			create max_priority_mode
			set_boolean_from_command_opt (max_priority_mode, "max_priority", "Use maximum priority threads")

			create function_integral.make (delta_count, task_count, thread_count, max_priority_mode.item)
			create procedure_integral.make (delta_count, task_count, thread_count, max_priority_mode.item)

			if max_priority_mode.item then
				priority := "maximum"
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
			from i := 1 until i > repetition_count or is_canceled loop
				do_calculation (
					"distributed integral using class EL_FUNCTION_DISTRIBUTER",
					agent: DOUBLE do Result := function_integral.integral_sum (agent wave.complex_sine_wave (?, term_count), 0, 2 * Pi) end
				)
				i := i + 1
			end
			from i := 1 until i > repetition_count or is_canceled loop
				do_calculation (
					"distributed integral using class EL_PROCEDURE_DISTRIBUTER",
					agent: DOUBLE do Result := procedure_integral.integral_sum (agent wave.complex_sine_wave (?, term_count), 0, 2 * Pi) end
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
			if not is_canceled then
				log.put_double_field ("integral", calculation.last_result)
				log.put_new_line
				log.put_elapsed_time
				log.put_new_line
			end
		end

	is_canceled: BOOLEAN
		do
			Result := function_integral.is_canceled or procedure_integral.is_canceled
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

	max_priority_mode: BOOLEAN_REF

	procedure_integral: PROCEDURE_INTEGRAL

	function_integral: FUNCTION_INTEGRAL

	wave: SINE_WAVE

feature {NONE} -- Constants

	Description: STRING = "Test distributed calculation of integrals"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{TEST_WORK_DISTRIBUTER_APP}, All_routines],
				[{PROCEDURE_INTEGRAL}, All_routines],
				[{FUNCTION_INTEGRAL}, All_routines]
			>>
		end

	Variable: TUPLE [delta_count, term_count, task_count, thread_count, repetition_count: STRING]
		once
			Result := ["delta_count", "term_count", "task_count", "thread_count", "repetition_count"]
		end

	Option_name: STRING = "work_distributer"

end
