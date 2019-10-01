note
	description: "A fix for the `reset' bug"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 18:10:01 GMT (Tuesday   1st   October   2019)"
	revision: "4"

class
	EL_HMAC_SHA_256

inherit
	HMAC_SHA256
		rename
			sink_string as sink_raw_string_8,
			sink_character as sink_raw_character_8
		redefine
			make, reset
		end

	EL_DATA_SINKABLE
		rename
			sink_natural_32 as sink_natural_32_be
		undefine
			is_equal
		end

create
	make, make_ascii_key

feature -- Initialization

	make (k: READABLE_INTEGER_X)
		do
			Precursor (k)
			create initial_message_hash.make_copy (message_hash)
		end

feature -- Measurement

	Byte_width: INTEGER = 32

feature -- Access

	digest: EL_DIGEST_ARRAY
		do
			create Result.make_from_integer_x (hmac)
		end

feature -- Element change

	reset
		do
			message_hash.make_copy (initial_message_hash)
			finished := False
		end

feature {NONE} -- Internal attributes

	initial_message_hash: SHA256_HASH

end
