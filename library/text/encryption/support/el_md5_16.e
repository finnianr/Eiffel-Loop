note
	description: "Summary description for {EL_MD5_16}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MD5_16

inherit
	MD5

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

feature -- Element change

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
