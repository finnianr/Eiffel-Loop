note
	description: "Summary description for {EL_MD5_16}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MD5_16

inherit
	MD5
		redefine
			make
		end

create
	make, make_copy

feature {NONE} -- Initialization

	make
		do
			Precursor
			create integer_bytes.make ({PLATFORM}.natural_32_bytes)
		end

feature -- Access	

	digest: ARRAY [NATURAL_8]
		do
			create Result.make (1, 16)
			current_final (Result.area, 0)
		end

feature -- Element change

	sink_integer (i: INTEGER)
		do
			integer_bytes.put_integer_32_be (i, 0)
			sink_natural_32_be (integer_bytes.read_natural_32 (0))
		end

	sink_array (a_array: ARRAY [NATURAL_8])
		local
			l_area: SPECIAL [NATURAL_8]
		do
			l_area := a_array
			sink_special (l_area, l_area.lower, l_area.upper)
		end

feature {NONE} -- Implementation

	integer_bytes: MANAGED_POINTER

end
