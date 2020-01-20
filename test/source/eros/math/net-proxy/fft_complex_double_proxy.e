note
	description: "Network proxy for remote instance of class [$source FFT_COMPLEX_DOUBLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 20:37:41 GMT (Monday 20th January 2020)"
	revision: "9"

class
	FFT_COMPLEX_DOUBLE_PROXY

inherit
	FFT_COMPLEX_DOUBLE_I
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

	input: COLUMN_VECTOR_COMPLEX_DOUBLE
			-- Processing instruction example:
			--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.input?>
		local
			l_result: EROS_MAKEABLE_RESULT [COLUMN_VECTOR_COMPLEX_DOUBLE]
		do
			log.enter (R_input)
			create l_result.make (Current, R_input, [])
			Result := l_result.item
			log.exit
		end

	length: INTEGER
			-- Processing instruction example:
			--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.length?>
		local
			l_result: EROS_RESULT [INTEGER]
		do
			log.enter (R_length)
			create l_result.make (Current, R_length, [])
			Result := l_result.item
			log.exit
		end

	output: COLUMN_VECTOR_COMPLEX_DOUBLE
			-- Processing instruction example:
			--		 <?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.output?>
		local
			l_result: EROS_MAKEABLE_RESULT [COLUMN_VECTOR_COMPLEX_DOUBLE]
		do
			log.enter (R_output)
			create l_result.make (Current, R_output, [])
			Result := l_result.item
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
		local
			l_result: EROS_RESULT [BOOLEAN]
		do
			log.enter (R_is_output_length_valid)
			create l_result.make (Current, R_is_output_length_valid, [])
			Result := l_result.item
			log.exit
		end

	is_power_of_two (n: INTEGER): BOOLEAN
		-- Processing instruction example:
		--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.is_power_of_two (256)?>
		local
			l_result: EROS_RESULT [BOOLEAN]
		do
			log.enter (R_is_power_of_two)
			create l_result.make (Current, R_is_power_of_two, [N])
			Result := l_result.item
			log.exit
		end

	is_valid_input_length (a_length: INTEGER): BOOLEAN
		-- Processing instruction example:
		--		<?call {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}.is_valid_input_length (256)?>
		local
			l_result: EROS_RESULT [BOOLEAN]
		do
			log.enter (R_is_valid_input_length)
			create l_result.make (Current, R_is_valid_input_length, [a_length])
			Result := l_result.item
			log.exit
		end

feature {NONE} -- Implementation

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
