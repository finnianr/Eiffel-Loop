note
	description: "[
		Common interface to local proxy interface and remote server class for calculating fourier transformations
	]"
	descendants: "[
			FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_I*
				[$source FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_PROXY]
				[$source FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 8:29:01 GMT (Monday 13th January 2020)"
	revision: "7"

deferred class
	FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_I

inherit
	FFT_ONCE_ROUTINE_NAMES

feature -- Initialization

	fft_make (n: INTEGER)
			--
		deferred
		end

feature -- Access

	input: COLUMN_VECTOR_COMPLEX_DOUBLE
			--
		deferred
		end

	output: COLUMN_VECTOR_COMPLEX_DOUBLE
   		--
		deferred
		end

	length: INTEGER
			--
		deferred
		end

	windower_rectangular: RECTANGULAR_WINDOWER_DOUBLE
			--
		deferred
		end

	windower_default: DEFAULT_WINDOWER_DOUBLE
			--
		deferred
		end

feature -- Basic operations

	do_transform
   			--
		deferred
		end

	do_inverse_transform
	   		--
		deferred
		end

feature -- Element change

   set_input (a_input: VECTOR_COMPLEX_DOUBLE)
   		--
		deferred
		end

	 set_windower (a_windower: WINDOWER_DOUBLE)
   		--
		deferred
		end

feature -- Contract support

	is_output_length_valid: BOOLEAN
			--
		deferred
		end

	is_valid_input_length (a_length: INTEGER): BOOLEAN
			--
		deferred
		end

	is_power_of_two (n: INTEGER): BOOLEAN
			--
		deferred
		end

feature {NONE} -- EROS implementation

	routines: ARRAY [TUPLE [STRING, ROUTINE]]
			--
		do
			Result := <<
				-- Procedures
				[R_do_transform,					agent do_transform],
				[R_do_inverse_transform,		agent do_inverse_transform],

				[R_fft_make,						agent fft_make],
				[R_set_input,						agent set_input],
				[R_set_windower,					agent set_windower],

				-- Functions
				[R_output,							agent: COLUMN_VECTOR_COMPLEX_DOUBLE do Result := output end],
				[R_input,							agent: COLUMN_VECTOR_COMPLEX_DOUBLE do Result := input end],
				[R_length,							agent: INTEGER do Result := length end],

				[R_is_output_length_valid,		agent is_output_length_valid],
				[R_is_valid_input_length,		agent is_valid_input_length],
				[R_is_power_of_two,				agent is_power_of_two],

				[R_windower_rectangular,		agent Windower_rectangular],
				[R_windower_default,				agent Windower_default]
			>>
		end

feature {NONE} -- Routine names

	R_fft_make: STRING = "fft_make"

	R_do_transform: STRING = "do_transform"

	R_do_inverse_transform: STRING = "do_inverse_transform"

	R_input: STRING = "input"

	R_output: STRING = "output"

	R_length: STRING = "length"

	R_set_input: STRING = "set_input"

	R_set_windower: STRING = "set_windower"

	R_is_output_length_valid: STRING = "is_output_length_valid"

	R_is_valid_input_length: STRING = "is_valid_input_length"

	R_is_power_of_two: STRING = "is_power_of_two"

end
