note
	description: "EROS test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EROS_TEST_SET

inherit
	EL_EQA_TEST_SET
		redefine
			on_prepare, on_clean
		end

	EROS_REMOTE_CALL_CONSTANTS undefine default_create end

	FFT_ONCE_ROUTINE_NAMES
		rename
			R_windower_rectangular as Windower_rectangular,
			R_windower_default as Windower_default
		undefine
			default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_LOG

feature {NONE} -- Initiliazation

	on_prepare
			--
		do
			create server.make (Port_number)
			server.launch
			Execution_environment.sleep (150) -- Try increasing if connection error occcurs
			create connection.make (Port_number, "localhost")
			signal_array := << create {SIGNAL_MATH}.make, create {SIGNAL_MATH_PROXY}.make (connection) >>
			fft_array := << create {FFT_COMPLEX_64}.make, create {FFT_COMPLEX_64_PROXY}.make (connection) >>
		end

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("fft", agent test_fft)
		end

feature -- Tests

	test_fft
		local
			wave_form, output: ARRAYED_LIST [COLUMN_VECTOR_COMPLEX_64]
			i_freq, log2_length: INTEGER; phase_fraction: DOUBLE
		do
			log.enter ("test_fft")
			connection.set_inbound_type (Type_plaintext)
			connection.set_outbound_type (Type_plaintext)

			i_freq := 4; log2_length := 7; phase_fraction := 0.5
			create wave_form.make (2)
			across signal_array as signal loop
				wave_form.extend (signal.item.cosine_waveform (i_freq, log2_length, phase_fraction))
			end
			assert ("wave forms approximately equal", wave_form.first.is_approximately_equal (wave_form.last, Precision))
			create output.make (2)
			across fft_array as fft loop
				do_fourier_transform (fft.item, wave_form [fft.cursor_index])
				output.extend (fft.item.output)
			end
			assert ("outputs approximately equal", output.first.is_approximately_equal (output.last, Precision))
			log.exit
		end

feature {NONE} -- Implementation

	do_fourier_transform (fft: FFT_COMPLEX_64_I; wave_form: COLUMN_VECTOR_COMPLEX_64)
		do
			log.enter_with_args ("do_fourier_transform", [fft.generator])
			if fft.is_power_of_two (wave_form.count) then
				fft.fft_make (wave_form.count)
				if attached {FFT_COMPLEX_64_PROXY} fft as proxy then
					proxy.set_windower (Windower_rectangular)
				else
					fft.set_windower (fft.Windower_rectangular)
				end
				if fft.is_valid_input_length (wave_form.count) then
					fft.set_input (wave_form)
					if fft.is_output_length_valid then
						fft.do_transform
					else
						assert ("is_output_length_valid (wave_form.count)", False)
					end
				else
					assert ("is_valid_input_length (wave_form.count)", False)
				end
			else
				assert ("is_power_of_two (wave_form.count)", False)
			end
			log.exit
		end

	on_clean
		do
			connection.close
			server.wait_to_stop
		end

feature {NONE} -- Internal attributes

	connection: EROS_CLIENT_CONNECTION

	server: EROS_SERVER_THREAD [SIGNAL_MATH, FFT_COMPLEX_64]

	signal_array: ARRAY [SIGNAL_MATH_I]

	fft_array: ARRAY [FFT_COMPLEX_64_I]

feature {NONE} -- Constants

	Port_number: INTEGER = 8000

	Precision: DOUBLE = 1.0e-10

end