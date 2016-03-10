note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_ARRAY_WRITER_DOUBLE

inherit
	EL_ARRAY_WRITER [DOUBLE]

feature {NONE} -- Implementation

	put_array_bounds (file: RAW_FILE; interval: INTEGER_INTERVAL)
			--
		do
			file.put_double (interval.lower.to_double)
			file.put_double (interval.upper.to_double)
		end

	put_item (file: RAW_FILE; item: DOUBLE)
			--
		do
			file.put_double (item)
		end

end
