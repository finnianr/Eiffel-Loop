note
	description: "Summary description for {EL_MD5_16}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-17 13:24:49 GMT (Thursday 17th November 2016)"
	revision: "2"

class
	EL_MD5_128

inherit
	MD5
		redefine
			reset
		end

	EL_MODULE_BASE_64
		undefine
			is_equal
		end

create
	make, make_copy

feature -- Access	

	digest: SPECIAL [NATURAL_8]
		do
			create Result.make_filled (0, 16)
			current_final (Result, 0)
		end

	digest_string: STRING
		local
			l_digest: like digest
		do
			l_digest := digest
			create Result.make_filled ('%U', 16)
			Result.area.base_address.memory_copy (l_digest.base_address, 16)
		end

	digest_base_64: STRING
		do
			Result := Base_64.encoded_special (digest)
		end

feature -- Element change

	reset
		do
			Precursor
			schedule.fill_with (0, 0, schedule.upper)
			buffer.fill_with (0, 0, buffer.upper)
		end

	sink_integer (i: INTEGER)
		do
			sink_natural_32_be (i.to_natural_32)
		end

	sink_array (a_array: ARRAY [NATURAL_8])
		local
			l_area: SPECIAL [NATURAL_8]
		do
			l_area := a_array
			sink_special (l_area, l_area.lower, l_area.upper)
		end

	sink_bytes (byte_array: EL_BYTE_ARRAY)
		local
			l_area: SPECIAL [NATURAL_8]
		do
			l_area := byte_array
			sink_special (l_area, l_area.lower, l_area.upper)
		end

end
