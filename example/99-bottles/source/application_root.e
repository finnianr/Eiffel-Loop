indexing
	description: "[
		Eiffel submission for website holding a collection of the Song 99 Bottles of Beer programmed 
		in different programming languages. Actually the song is represented in 1500 different
		programming languages and variations.
		See: [http://www.99-bottles-of-beer.net/language-eiffel:-analysis,-design-and-programming-2256.html 1st submission 12 May 2009]
		and [http://www.99-bottles-of-beer.net/language-eiffel-2259.html 2nd submission 12th June 2009]
	]"

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
