note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_ARRAY_WRITER [G -> NUMERIC]

feature -- Basic operations

	save_array_double (values: ARRAY [G]; file_path: STRING)
			--
		local
			i: INTEGER
			file: RAW_FILE
		do
			create file.make_open_write (file_path)
			put_array_bounds (file, values.lower |..| values.upper)
			from i := values.lower until i > values.upper loop
				put_item (file, values.item (i))
				i := i + 1
			end
			file.close
		end

feature {NONE} -- Implementation

	put_array_bounds (file: RAW_FILE; interval: INTEGER_INTERVAL)
			--
		deferred
		end

	put_item (file: RAW_FILE; item: G)
			--
		deferred
		end

end
