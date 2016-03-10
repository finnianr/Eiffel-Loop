note
	description: "Summary description for {SIGNAL_MATH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:06 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	SIGNAL_MATH

inherit
	SIGNAL_MATH_I

	EL_REMOTELY_ACCESSIBLE
		rename
			No_procedures as procedures
		end

create
	make

feature -- Basic operations

	cosine_waveform (i_freq, log2_length: INTEGER; phase_fraction: DOUBLE): COLUMN_VECTOR_COMPLEX_DOUBLE
   			-- create a sinusoidal wave
   			-- (From Greg Lee's Numeric Eiffel Library test suite)
		local
			c: COMPLEX_DOUBLE
			i_period, i, n: INTEGER
			y, r: DOUBLE
			      do
			n := (2 ^ log2_length).rounded

			i_period := n // i_freq

			y := (2.0 * Pi) / (1.0 * n)

			create Result.make_with_size (n)
			from i := 1 until i > Result.height loop
				r := cosine (i_freq * y * (i - 1 - phase_fraction * i_period))
				c.set(r, 0.0)
				Result.put( c, i )
				i := i + 1
			end
		end

feature {NONE} -- EROS implementation

	functions: ARRAY [like function_mapping]
			--
		do
			Result := <<
				["cosine_waveform", agent cosine_waveform]
			>>
		end

end
