note
	description: "Array writer double"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

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