note
	description: "Fast fourier transform complex double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 16:27:51 GMT (Sunday 12th January 2020)"
	revision: "6"

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

end
