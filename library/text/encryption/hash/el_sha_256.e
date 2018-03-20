note
	description: "Summary description for {EL_SHA_256}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-16 11:04:29 GMT (Friday 16th February 2018)"
	revision: "3"

class
	EL_SHA_256

inherit
	SHA256
		rename
			sink_string as sink_raw_string_8,
			sink_character as sink_raw_character_8
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

feature -- Element change

	reset
		do
			Precursor
			byte_count := 0
		end
end
