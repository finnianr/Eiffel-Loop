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
	date: "2020-01-10 8:23:18 GMT (Friday 10th January 2020)"
	revision: "5"

deferred class
	FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE_I

feature -- Initialization

	fft_make (n: INTEGER)
			--
		deferred
		end

feature -- Access

	input: VECTOR_COMPLEX_DOUBLE
			--
		deferred
		end

	output: VECTOR_COMPLEX_DOUBLE
   		--
   		deferred
   		end

	length: INTEGER
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

   set_input (a_input: like input)
   		--
   		deferred
   		end

   set_windower (windower: EL_EIFFEL_IDENTIFIER)
   		--
   		require
   			valid_name: (<< Identifier_default_windower, Identifier_rectangular_windower >>).has (windower)
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

feature -- Constants

	Identifier_default_windower: EL_EIFFEL_IDENTIFIER
			--
		once
			create Result.make_from_string ("Default_windower")
		end

	Identifier_rectangular_windower: EL_EIFFEL_IDENTIFIER
			--
		once
			create Result.make_from_string ("Rectangular_windower")
		end

	Windower_types: ARRAY [EL_EIFFEL_IDENTIFIER]
			--
		once
			Result := << Identifier_default_windower, Identifier_rectangular_windower >>
		end

end
