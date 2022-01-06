note
	description: "Sha 256"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-05 11:52:30 GMT (Wednesday 5th January 2022)"
	revision: "7"

class
	EL_SHA_256

inherit
	SHA256
		rename
			sink_string as sink_raw_string_8,
			sink_character as sink_raw_character_8,
			sink_special as sink_special_reversed,
			sink_special_lsb as sink_special
		redefine
			reset
		end

	EL_DATA_SINKABLE
		rename
			sink_natural_32 as sink_natural_32_be
		undefine
			is_equal
		end

create
	make

feature -- Measurement

	Byte_width: INTEGER = 32

feature -- Element change

	reset
		do
			Precursor
			byte_count := 0
		end
end