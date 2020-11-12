note
	description: "Fourier math test client app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-12 15:42:04 GMT (Thursday 12th November 2020)"
	revision: "18"

class
	FOURIER_MATH_CLIENT_TEST_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Ask_user_to_quit, Application_option
		end

	EL_MODULE_EVOLICITY_TEMPLATES

	FFT_ONCE_ROUTINE_NAMES
		rename
			R_windower_rectangular as Windower_rectangular,
			R_windower_default as Windower_default
		end

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		local
			time: TIME
		do
			create connection.make (8000, "localhost")

			create signal_math.make (connection)
			create fft.make (connection)

			connection.set_inbound_type (Application_option.protocol)
			connection.set_outbound_type (Application_option.protocol)

			create random.make
			create time.make_now
			random.set_seed (time.compact_time)

			Evolicity_templates.set_horrible_indentation
		end

feature -- Basic operations

	basic_test (i_freq, log2_length: INTEGER; phase_fraction: DOUBLE; windower_id: STRING)
			--
		local
			test_wave_form: COLUMN_VECTOR_COMPLEX_64
			preconditions_ok: BOOLEAN
		do
			test_wave_form := signal_math.cosine_waveform (i_freq, log2_length, phase_fraction)

			if not signal_math.has_error then
				print_vector (test_wave_form)
				if fft.is_power_of_two (test_wave_form.count) then
					fft.fft_make (test_wave_form.count)
					fft.set_windower (windower_id)
					if fft.is_valid_input_length (test_wave_form.count) then
						fft.set_input (test_wave_form)

						if fft.is_output_length_valid then
							preconditions_ok := true
							fft.do_transform
							if not fft.has_error and fft.last_procedure_call_ok then
								print_vector (fft.output)
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

	random_test
			--
		local
			phase_fraction: DOUBLE
			i_freq, log2_length: INTEGER
			windower_id: STRING
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
			windower_id := Windower_id_set [random.item \\ 2 + 1]

			basic_test (i_freq, log2_length, phase_fraction, windower_id)
			log.exit
		end

	repeat_random_tests
			--
		local
			timer: EL_EXECUTION_TIMER
		do
			create timer.make
			timer.start
			from until timer.elapsed_time.seconds_count > Application_option.running_time_secs loop
				random_test
				timer.update
			end
		end

	run
			--
		do
			log.enter ("run")

			basic_test (4, 7, 0.5, Windower_rectangular)
			basic_test (2, 7, 0.1, Windower_rectangular)
			basic_test (8, 8, 0.7, Windower_default)

			repeat_random_tests

			connection.close
			log.exit
		end

feature {NONE} -- Implementation

	log_filter_set: EL_LOG_FILTER_SET [
		like Current,
		EROS_CALL_REQUEST_HANDLER_PROXY,
		FFT_COMPLEX_64_PROXY,
		SIGNAL_MATH_PROXY
	]
		do
			create Result.make
		end

	print_vector (vector: VECTOR_COMPLEX_64)
			--
		local
			c: COMPLEX_DOUBLE; i: INTEGER
		do
			log.enter ("print_vector")
			lio.put_string ("Vector rows [10 of ")
			lio.put_integer (vector.count)
			lio.put_line ("]:")
			from i := 1 until i > 10 loop
				c := vector [i]
				lio.put_integer (i)
				lio.put_string (": "); lio.put_double (c.r)
				lio.put_string (" + "); lio.put_double (c.i); lio.put_line ("i")
				i := i + 1
			end
			lio.put_line ("..")
			log.exit
		end

feature {NONE} -- Internal attributes

	connection: EROS_CLIENT_CONNECTION

	random: RANDOM

	fft: FFT_COMPLEX_64_PROXY

	signal_math: SIGNAL_MATH_PROXY

feature {NONE} -- Constants

	Application_option: EROS_APPLICATION_COMMAND_OPTIONS
		once
			create Result.make
		end

	Ask_user_to_quit: BOOLEAN = true

	Description: STRING = "Test client to generate random wave forms and do fourier transforms for 25 seconds"

end