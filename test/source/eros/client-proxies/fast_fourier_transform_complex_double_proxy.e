note
	description: "Fast fourier transform complex double proxy"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-16 13:46:14 GMT (Thursday 16th January 2020)"
	revision: "6"

class
	FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_PROXY

inherit
	FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_I
		rename
			set_windower as remote_set_windower
		export
			{NONE} remote_set_windower
			{ANY} Windower_id_set
		end

	EL_REMOTE_PROXY

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

	input: COLUMN_VECTOR_COMPLEX_DOUBLE
			-- Processing instruction example:
			--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.input?>
		do
			log.enter (R_input)
			call (R_input, [])
			if not has_error and then attached {like input} result_object as object then
				Result := object
			else
				create Result.make
			end
			log.exit
		end

	length: INTEGER
			-- Processing instruction example:
			--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.length?>
		do
			log.enter (R_length)
			call (R_length, [])
			if not has_error and then result_string.is_integer then
				Result := result_string.to_integer
			end
			log.exit
		end

	output: COLUMN_VECTOR_COMPLEX_DOUBLE
			-- Processing instruction example:
			--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.output?>
		do
			log.enter (R_output)
			call (R_output, [])
			if not has_error and then attached {like output} result_object as l_result then
				Result := l_result
			else
				create Result.make
			end
			log.exit
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
			call (R_is_output_length_valid, [])
			if not has_error and then result_string.is_boolean then
				Result := result_string.to_boolean
			end
			log.exit
		end

	is_power_of_two (n: INTEGER): BOOLEAN
			-- Processing instruction example:
			--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.is_power_of_two (256)?>
		do
			log.enter (R_is_power_of_two)
			call (R_is_power_of_two, [n])
			if not has_error and then result_string.is_boolean then
				Result := result_string.to_boolean
			end
			log.exit
		end

	is_valid_input_length (a_length: INTEGER): BOOLEAN
			-- Processing instruction example:
			--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.is_valid_input_length (256)?>
		do
			log.enter (R_is_valid_input_length)
			call (R_is_valid_input_length, [a_length])
			if not has_error and then result_string.is_boolean then
				Result := result_string.to_boolean
			end
			log.exit
		end

feature {NONE} -- Implementation

	 remote_set_windower (a_windower: WINDOWER_DOUBLE)
	 	do
	 	end

end
