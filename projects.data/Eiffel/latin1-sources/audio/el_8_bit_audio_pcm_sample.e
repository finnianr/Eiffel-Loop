note
	description: "[
		
		8-bit PCM data contained in WAV files is usually stored as
		unsigned numbers, whereas the LM4549 codec (and most 16-bit WAV files) work with signed
		quantities. Attempting to play unsigned samples directly will produce a horribly distorted
		waveform. Thus, when playing unsigned sample data, an offset which corresponds to the mid-point 
		value must be deducted from each sample value. For 8-bit unsigned values, this offset is 0x7F
		
		NOTES: not tested but should work
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_8_BIT_AUDIO_PCM_SAMPLE

inherit
	EL_AUDIO_PCM_SAMPLE
		rename
			Integer_8_bytes as bytes
		end

create
	make

feature {NONE} -- Implementation

	read_value: INTEGER
			--
		do
			Result := read_integer_8 (0)
		end

	put_value (a_value: like value)
			-- Set `value' to `a_value'.
		do
			put_integer_8 (a_value.to_integer_8, 0)
		end

feature -- Constants

	Max_value: INTEGER_64
			--
		local
			l_value: INTEGER_8
		once
			Result := (l_value.Max_value).to_integer_64 + 1
		end

	Min_value: INTEGER
			--
		local
			l_value: INTEGER_8
		once
			Result := l_value.Min_value
		end

	Bias: INTEGER = 128

end
