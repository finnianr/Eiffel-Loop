note
	description: "MD5 128"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 7:37:51 GMT (Sunday 25th August 2024)"
	revision: "17"

class
	EL_MD5_128

inherit
	MD5
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
		end

	EL_MODULE_BASE_64

create
	make, make_copy

convert
	to_uuid: {EL_UUID}

feature -- Measurement

	Byte_width: INTEGER = 16

feature -- Access	

	digest: SPECIAL [NATURAL_8]
		do
			create Result.make_filled (0, 16)
			current_final (Result, 0)
		end

	digest_base_64: STRING
		do
			Result := Base_64.encoded_special (digest, False)
		end

	digest_string: STRING
		local
			l_digest: like digest
		do
			l_digest := digest
			create Result.make_filled ('%U', 16)
			Result.area.base_address.memory_copy (l_digest.base_address, 16)
		end

	to_uuid: EL_UUID
		local
			array: like UUID_array
		do
			array := UUID_array
			current_final (array.area, 0)
			create Result.make_from_array (array)
		end

feature -- Element change

	reset
		do
			Precursor
			schedule.fill_with (0, 0, schedule.upper)
			buffer.fill_with (0, 0, buffer.upper)
		end

feature {NONE} -- Constants

	UUID_array: ARRAY [NATURAL_8]
		once
			create Result.make_filled (0, 1, 16)
		end

end