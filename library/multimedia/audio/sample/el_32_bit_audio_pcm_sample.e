note
	description: "32 bit audio pcm sample"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_32_BIT_AUDIO_PCM_SAMPLE

inherit
	EL_AUDIO_PCM_SAMPLE
		rename
			Integer_32_bytes as Bytes
		end

create
	make

feature {NONE} -- Implementation

	read_value: INTEGER
			--
		do
			Result := read_integer_32_le (0)
		end

	put_value (a_value: like value)
			--
		do
			-- Windows wave is little endian
			put_integer_32_le (a_value.to_integer_32, 0)
		end

feature -- Constants

	Max_value: INTEGER_64
			--
		local
			l_value: INTEGER_32
		once
			Result := (l_value.Max_value).to_integer_64 + 1
		end

	Min_value: INTEGER
			--
		local
			l_value: INTEGER_32
		once
			Result := l_value.Min_value
		end

	Bias: INTEGER = 0

end