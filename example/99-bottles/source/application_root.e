indexing
	description: "Summary description for {APPLICATION_ROOT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	APPLICATION_ROOT

create
	make

feature {NONE} -- Initialization

	make is
			--
		local
			short_ver: THE_SHORT_99_BOTTLES_OF_BEER_APPLICATION
			long_ver: THE_99_BOTTLES_OF_BEER_APPLICATION
			input_string: STRING
		do
			io.put_string ("1. Short version")
			io.put_new_line
			io.put_string ("2. Long version")
			io.put_new_line
			io.put_string ("Enter application number: (or return to quit) ")
			io.read_line
			input_string := io.last_string
			if input_string.is_integer and then
				input_string.to_integer >= 1 and input_string.to_integer <= 2
			then
				inspect input_string.to_integer
					when 1 then
						create short_ver.make

					when 2 then
						create long_ver.make

				end
			end
		end

end
