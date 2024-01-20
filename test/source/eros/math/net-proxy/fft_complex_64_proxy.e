note
	description: "Network proxy for remote instance of class ${FFT_COMPLEX_64}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "13"

class
	FFT_COMPLEX_64_PROXY

inherit
	FFT_COMPLEX_64_I
		rename
			set_windower as remote_set_windower
		export
			{NONE} remote_set_windower
			{ANY} Windower_id_set
		end

	EROS_PROXY

create
	make

feature -- Initialization

	fft_make (n: INTEGER)
			--
			-- Processing instruction example:
			--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.fft_make (128)?>
		require else
				n_is_power_of_two: is_power_of_two (n)
		do
			log.enter (R_fft_make)
			call (R_fft_make, [n])
			log.exit
		end

feature -- Access

	input: COLUMN_VECTOR_COMPLEX_64
			-- Processing instruction example:
			--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.input?>
		do
			log.enter (R_input)
			Result := column_vector_complex_64_call (R_input, [])
			log.exit
		end

	length: INTEGER
			-- Processing instruction example:
			--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.length?>
		do
			log.enter (R_length)
			Result := integer_call (R_length, [])
			log.exit
		end

	output: COLUMN_VECTOR_COMPLEX_64
			-- Processing instruction example:
			--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.output?>
		do
			log.enter (R_output)
			Result := column_vector_complex_64_call (R_output, [])
			log.exit
		end

feature -- Basic operations

	do_inverse_transform
			-- Processing instruction example:
			--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.do_inverse_transform?>
		require else
				valid_output_length: is_output_length_valid
		do
			log.enter (R_do_inverse_transform)
			call (R_do_inverse_transform, [])
			log.exit
		end

	do_transform
			-- Processing instruction example:
			--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.do_transform?>
		require else
				valid_output_length: is_output_length_valid
			do
			log.enter (R_do_transform)
			call (R_do_transform, [])
			log.exit
			end

feature -- Element change

	set_input (a_input: like input)
		-- Processing instruction example:
		--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.set_input ({COLUMN_VECTOR_COMPLEX_DOUBLE})?>
		require else
				valid_input_length: is_valid_input_length (a_input.length)
		do
			log.enter (R_set_input)
			call (R_set_input, [a_input])
			log.exit
		end

	set_windower (a_windower_id: STRING)
		-- Processing instruction example:
		--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.set_windower (Rectangular_windower)?>
		require
			valid_windower: Windower_id_set.has (a_windower_id)
		do
			log.enter (R_set_windower)
			call (R_set_windower, [a_windower_id])
			log.exit
		end

feature -- Contract support

	is_output_length_valid: BOOLEAN
		-- Processing instruction example:
		--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.is_output_length_valid?>
		do
			log.enter (R_is_output_length_valid)
			Result := boolean_call (R_is_output_length_valid, [])
			log.exit
		end

	is_power_of_two (n: INTEGER): BOOLEAN
		-- Processing instruction example:
		--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.is_power_of_two (256)?>
		do
			log.enter (R_is_power_of_two)
			Result := boolean_call (R_is_power_of_two, [N])
			log.exit
		end

	is_valid_input_length (a_length: INTEGER): BOOLEAN
		-- Processing instruction example:
		--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.is_valid_input_length (256)?>
		do
			log.enter (R_is_valid_input_length)
			Result := boolean_call (R_is_valid_input_length, [a_length])
			log.exit
		end

feature {NONE} -- Implementation

	column_vector_complex_64_call (routine_name: STRING; argument_tuple: TUPLE): COLUMN_VECTOR_COMPLEX_64
		do
			Result := create {EROS_MAKEABLE_RESULT [COLUMN_VECTOR_COMPLEX_64]}.make_call (
				Current, routine_name, argument_tuple
			)
		end

	remote_set_windower (a_windower: WINDOWER_DOUBLE)
		do
		end

	windower_default: DEFAULT_WINDOWER_DOUBLE
			--
		do
			call (R_windower_default, [])
		end

	windower_rectangular: RECTANGULAR_WINDOWER_DOUBLE
			--
		do
			call (R_windower_rectangular, [])
		end

end