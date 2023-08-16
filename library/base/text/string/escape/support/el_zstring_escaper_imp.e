note
	description: "[$source ZSTRING] implementation of [$source EL_STRING_ESCAPER_IMP [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 14:35:54 GMT (Wednesday 2nd August 2023)"
	revision: "17"

class
	EL_ZSTRING_ESCAPER_IMP

inherit
	EL_STRING_ESCAPER_IMP [ZSTRING]
		undefine
			bit_count
		redefine
			to_code, to_unicode, make
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

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

feature -- Basic operations

	prepend_character (str: ZSTRING; uc: CHARACTER_32)
		do
			str.prepend_character (uc)
		end

feature {NONE} -- Implementation

	to_unicode (z_code: NATURAL): NATURAL
		do
			Result := codec.z_code_as_unicode (z_code)
		end

feature {NONE} -- Internal attributes

	codec: like Shared_codec

end