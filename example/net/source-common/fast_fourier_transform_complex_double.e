note
	description: "Summary description for {FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:06 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE

inherit
	FFT_COMPLEX_DOUBLE
		rename
			fft as do_transform,
			ifft as do_inverse_transform,
			make as fft_make,
			log as logarithm
		redefine
			output, input, fft_make, set_windower
		end

	FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_I
		rename
			set_windower as set_windower_by_name
		end

	EL_REMOTELY_ACCESSIBLE

create
	make, fft_make

feature -- Initialization

	fft_make (n: INTEGER)
			--
		do
			Precursor {FFT_COMPLEX_DOUBLE} (n)
			create output.make_with_size (length)
		end

feature -- Access

   output: COLUMN_VECTOR_COMPLEX_DOUBLE

   input: COLUMN_VECTOR_COMPLEX_DOUBLE

feature -- Contract support

	is_output_length_valid: BOOLEAN
			--
		do
			Result := output.length = length
		end

	is_valid_input_length (a_length: INTEGER): BOOLEAN
			--
		do
			Result := length = a_length
		end

feature -- Element change

	set_windower (a_windower: WINDOWER_DOUBLE)
			--
		do
			a_windower.make (length)
			Precursor (a_windower)
		end

feature {NONE} -- Reflection access

	get_output: COLUMN_VECTOR_COMPLEX_DOUBLE
		--
		do
			Result := output
		end

	get_input: COLUMN_VECTOR_COMPLEX_DOUBLE
		--
		do
			Result := input
		end

	get_length: INTEGER
			--
		do
			Result := length
		end


feature {NONE} -- EROS implementation

	procedures: ARRAY [like procedure_mapping]
			--
		do
			Result := <<
				["do_transform", agent do_transform],
				["do_inverse_transform", agent do_inverse_transform],

				["fft_make", agent fft_make],
				["set_input", agent set_input],
				["set_windower", agent set_windower]
			>>
		end

	functions: ARRAY [like function_mapping]
			--
		do
			Result := <<
				["output", agent get_output],
				["input", agent get_input],
				["length", agent get_length],

				["is_output_length_valid", agent is_output_length_valid],
				["is_valid_input_length", agent is_valid_input_length],
				["is_power_of_two", agent is_power_of_two],

				[Identifier_rectangular_windower, agent Rectangular_windower],
				[Identifier_default_windower, agent Default_windower]
			>>
		end

feature {NONE} -- Unused

   set_windower_by_name (a_windower: EL_EIFFEL_IDENTIFIER)
   		--
   		do
   		end

feature -- Constants

	Rectangular_windower: RECTANGULAR_WINDOWER_DOUBLE
			--
		once
			create Result.make (1)
		end

	Default_windower: DEFAULT_WINDOWER_DOUBLE
			--
		once
			create Result.make (1)
		end

end
