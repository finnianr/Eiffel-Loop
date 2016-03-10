note
	description: "Summary description for {FOURIER_MATH_TEST_CLIENT_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:12 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	FOURIER_MATH_TEST_CLIENT_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Ask_user_to_quit, option_name, Installer
		end

	APPLICATION_MENUS

	EL_REMOTE_CALL_CONSTANTS

	EL_MODULE_EVOLICITY_TEMPLATES

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		local
			time: TIME
		do
			create signal_math
			create fast_fourier_transform

			create connection.make (8001, "localhost")
			connection.link (<< signal_math, fast_fourier_transform >>)

			Args.set_boolean_from_word_option ("binary", agent set_binary_transmission)

			if is_binary_transmission then
				connection.set_inbound_transmission_type (Transmission_type_binary)
				connection.set_outbound_transmission_type (Transmission_type_binary)
			end

			create random.make
			create time.make_now
			random.set_seed (time.compact_time)
			Args.set_integer_from_word_option ("duration", agent set_running_time_secs, 5)

			Evolicity_templates.set_horrible_indentation
		end

feature -- Basic operations

	run
			--
		do
			log.enter ("run")

			basic_test (4, 7, 0.5, fast_fourier_transform.Rectangular_windower)
			basic_test (2, 7, 0.1, fast_fourier_transform.Rectangular_windower)
			basic_test (8, 8, 0.7, fast_fourier_transform.Default_windower)

			repeat_random_tests

			connection.close
			log.exit
		end

	basic_test (i_freq, log2_length: INTEGER; phase_fraction: DOUBLE; windower: EL_EIFFEL_IDENTIFIER)
			--
		local
			test_wave_form: COLUMN_VECTOR_COMPLEX_DOUBLE
			preconditions_ok: BOOLEAN
		do
			test_wave_form := signal_math.cosine_waveform (i_freq, log2_length, phase_fraction)

			if not signal_math.has_error then
				print_vector (test_wave_form)

				if fast_fourier_transform.is_power_of_two (test_wave_form.count) then
					fast_fourier_transform.fft_make (test_wave_form.count)
					fast_fourier_transform.set_windower (windower)
					if fast_fourier_transform.is_valid_input_length (test_wave_form.count) then
						fast_fourier_transform.set_input (test_wave_form)

						if fast_fourier_transform.is_output_length_valid then
							preconditions_ok := true
							fast_fourier_transform.do_transform
							if not fast_fourier_transform.has_error and fast_fourier_transform.last_procedure_call_ok then
								print_vector (fast_fourier_transform.output)
							else
								log.put_line ("ERROR: call to do_transform failed")
							end
						end
					end
				end
				if not preconditions_ok then
					log.put_line ("ERROR: FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE requirement failed")
				end
			else
				log.put_line ("ERROR: signal_math.cosine_waveform failed")
			end
		end

	repeat_random_tests
			--
		local
			timer: EL_EXECUTION_TIMER
		do
			create timer.make
			timer.start
			from until timer.elapsed_time.seconds_count > running_time_secs loop
				random_test
				timer.update
			end
		end

	random_test
			--
		local
			phase_fraction: DOUBLE
			i_freq, log2_length: INTEGER
			windower: EL_EIFFEL_IDENTIFIER
		do
			log.enter ("random_test")
			random.forth
			phase_fraction := random.double_item

			random.forth
			i_freq := (random.item \\ 2 + 1) * 4
			check
				valid_i_freq: i_freq = 4 or i_freq = 8
			end

			random.forth
			log2_length := random.item \\ 7 + 4
			check
				correct_range: (4 |..| 10).has (log2_length)
			end

			random.forth
			windower := fast_fourier_transform.Windower_types [random.item \\ 2 + 1]

			basic_test (i_freq, log2_length, phase_fraction, windower)
			log.exit
		end

feature -- Element change

	set_running_time_secs (running_time: INTEGER)
			--
		do
			running_time_secs := running_time
		end

	set_binary_transmission (flag: BOOLEAN)
			--
		do
			is_binary_transmission := flag
		end

feature {NONE} -- Implementation

	print_vector (vector: VECTOR_COMPLEX_DOUBLE)
			--
		local
			i: INTEGER
			c: COMPLEX_DOUBLE
		do
			log.enter ("print_vector")
			log_or_io.put_string ("Vector rows [10 of ")
			log_or_io.put_integer (vector.count)
			log_or_io.put_line ("]:")
			from i := 1 until i > 10 loop
				c := vector [i]
				log_or_io.put_integer (i)
				log_or_io.put_string (": "); log_or_io.put_double (c.r)
				log_or_io.put_string (" + "); log_or_io.put_double (c.i); log_or_io.put_line ("i")
				i := i + 1
			end
			log_or_io.put_line ("..")
			log.exit
		end

	running_time_secs: INTEGER

	random: RANDOM

	connection: EL_EROS_CLIENT_CONNECTION

	is_binary_transmission: BOOLEAN

feature {NONE} -- Remote objects

	signal_math: SIGNAL_MATH_PROXY

	fast_fourier_transform: FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_PROXY

feature {NONE} -- Constants

	Ask_user_to_quit: BOOLEAN = true

	Option_name: STRING = "test_client"

	Description: STRING = "Test client to generate random wave forms and do fourier transforms for 25 seconds"

	Installer: EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER
			--
		once
			create Result.make (Current, Menu_path, new_launcher ("Fourier math test client", Icon_path_client_menu))
			Result.set_command_line_options ("-logging -duration 20")
			Result.set_terminal_position (200, 400)
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{FOURIER_MATH_TEST_CLIENT_APP}, "*"],
				[{FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_PROXY}, "*"],
				[{SIGNAL_MATH_PROXY}, "*"],
				[{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_PROXY}, "*"]
			>>
		end

end
