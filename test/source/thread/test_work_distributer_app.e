note
	description: "[
		Example program to demonstrate use of [$source EL_FUNCTION_DISTRIBUTER] and [$source EL_PROCEDURE_DISTRIBUTER]
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
	date: "2020-01-08 13:27:25 GMT (Wednesday 8th January 2020)"
	revision: "12"

class
	TEST_WORK_DISTRIBUTER_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Option_name, initialize, Application_option
		end

	EL_ARGUMENT_TO_ATTRIBUTE_SETTING

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
		do
			log.enter ("initialize")
			create wave

			lio.put_line ("COMMAND LINE OPTIONS")
			Application_option.print_fields (log)

			create function_integral.make (delta_count, task_count, thread_count, Application_option.max_priority)
			create procedure_integral.make (delta_count, task_count, thread_count, Application_option.max_priority)

			log.put_labeled_string ("Thread priority", Application_option.priority_name)
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
				agent: DOUBLE do
					Result := integral (agent wave.complex_sine_wave (?, term_count), 0, 2 * Pi, delta_count)
				end
			)
			from i := 1 until i > repetition_count or is_canceled loop
				do_calculation (
					"distributed integral using class EL_FUNCTION_DISTRIBUTER",
					agent: DOUBLE do
						Result := function_integral.integral_sum (agent wave.complex_sine_wave (?, term_count), 0, 2 * Pi)
					end
				)
				i := i + 1
			end
			from i := 1 until i > repetition_count or is_canceled loop
				do_calculation (
					"distributed integral using class EL_PROCEDURE_DISTRIBUTER",
					agent: DOUBLE do
						Result := procedure_integral.integral_sum (agent wave.complex_sine_wave (?, term_count), 0, 2 * Pi)
					end
				)
				i := i + 1
			end
			log.exit
		end

feature {NONE} -- Implementation

	delta_count: INTEGER
		do
			Result := Application_option.delta_count
		end

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

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{TEST_WORK_DISTRIBUTER_APP}, All_routines],
				[{PROCEDURE_INTEGRAL}, All_routines],
				[{FUNCTION_INTEGRAL}, All_routines]
			>>
		end

	repetition_count: INTEGER
		do
			Result := Application_option.repetition_count
		end

	task_count: INTEGER
		do
			Result := Application_option.task_count
		end

	term_count: INTEGER
		do
			Result := Application_option.term_count
		end

	thread_count: INTEGER
		do
			Result := Application_option.thread_count
		end

feature {NONE} -- Internal attributes

	count_arguments: HASH_TABLE [INTEGER_REF, STRING]

	function_integral: FUNCTION_INTEGRAL

	procedure_integral: PROCEDURE_INTEGRAL

	wave: SINE_WAVE

feature {NONE} -- Constants

	Application_option: TEST_WORK_DISTRIBUTER_COMMAND_OPTIONS
		once
			create Result.make
		end

	Description: STRING = "Test distributed calculation of integrals"

	Option_name: STRING = "work_distributer"

end
