note
	description: "Array writer double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:03 GMT (Saturday 19th May 2018)"
	revision: "3"

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