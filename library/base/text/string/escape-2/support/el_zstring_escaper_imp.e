note
	description: "[$source EL_ZSTRING] implementation of [$source EL_STRING_ESCAPER_IMP [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 10:54:23 GMT (Wednesday 4th January 2023)"
	revision: "13"

class
	EL_ZSTRING_ESCAPER_IMP

inherit
	EL_STRING_ESCAPER_IMP [ZSTRING]
		redefine
			to_code, make
		end

	EL_SHARED_ZSTRING_CODEC
		rename
			Codec as Shared_codec
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			codec := Shared_codec
		end

feature -- Conversion

	to_code (uc: CHARACTER_32): NATURAL
		do
			Result := codec.as_z_code (uc)
		end

feature -- Access

	empty_buffer: like buffer
		do
			Result := buffer
			Result.wipe_out
		end

feature {NONE} -- Internal attributes

	codec: like Shared_codec

end