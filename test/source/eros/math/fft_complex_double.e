note
	description: "Fast fourier transform for complex doubles"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 8:16:57 GMT (Monday 20th January 2020)"
	revision: "9"

class
	FFT_COMPLEX_DOUBLE

inherit
	NEL_FFT_COMPLEX_DOUBLE
		rename
			fft as do_transform,
			ifft as do_inverse_transform,
			make as fft_make,
			log as logarithm
		redefine
			output, input, fft_make, set_windower
		end

	FFT_COMPLEX_DOUBLE_I

	EROS_REMOTELY_ACCESSIBLE

create
	make, fft_make

feature -- Initialization

	fft_make (n: INTEGER)
			--
		do
			Precursor {NEL_FFT_COMPLEX_DOUBLE} (n)
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

feature {NONE} -- Constants

	Windower_rectangular: RECTANGULAR_WINDOWER_DOUBLE
			--
		once
			create Result.make (1)
		end

	Windower_default: DEFAULT_WINDOWER_DOUBLE
			--
		once
			create Result.make (1)
		end

end
