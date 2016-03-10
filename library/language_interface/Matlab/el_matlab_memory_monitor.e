note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MATLAB_MEMORY_MONITOR

inherit
	EL_LOGGING

feature -- Element change

	allocate (vector: EL_MATLAB_C_TYPE; count: INTEGER)
			--
		do
			mx_count := mx_count + count
			allocate_call_count := allocate_call_count + 1

			if allocate_call_count \\ 100 = 1 then
				log.enter_with_args ("allocate", << count >>)
				log.put_string (vector.generating_type)
				log.put_integer_field (" mx_count", mx_count)
				log.put_new_line
				log.exit
			end
		end

	free (vector: EL_MATLAB_C_TYPE; count: INTEGER)
			--
		do
			mx_count := mx_count - count
			free_call_count := free_call_count + 1

			if free_call_count \\ 100 = 1 then
				log.enter_with_args ("free", << count >>)
				log.put_string (vector.generating_type)
				log.put_integer_field (" mx_count", mx_count)
				log.put_new_line
				log.exit
			end
		end

feature {NONE} -- Implementation

	mx_count: INTEGER

	allocate_call_count: INTEGER

	free_call_count: INTEGER

end
