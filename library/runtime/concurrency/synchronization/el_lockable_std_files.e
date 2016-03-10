note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_LOCKABLE_STD_FILES

obsolete		
	"Use EL_LOG. Global instance obtainable from EL_LOGGING"

feature -- Basic operations

	put_line (message: STRING)
			--
		do
			io.put_string (message)
			io.put_new_line
		end

	put_string (message: STRING)
			--
		do
			io.put_string (message)
		end

	put_integer (n: INTEGER)
			--
		do
			io.put_integer (n)
		end

	put_character (c: CHARACTER)
			--
		do
			io.put_character (c)
		end

	put_real (r: REAL)
			--
		do
			io.put_real (r)
		end

	new_line
			--
		do
			io.put_new_line
		end

end



