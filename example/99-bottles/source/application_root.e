note
	description: "[
		Three Eiffel submissions for website demonstrating how to generate the lyrics of the song "99 Bottles of Beer"
		using over 1500 programming languages and variations.
		
		1. [http://www.99-bottles-of-beer.net/language-eiffel:-analysis,-design-and-programming-2256.html Submission 12 May 2009]
		2. [http://www.99-bottles-of-beer.net/language-eiffel-2259.html Submission 12th June 2009]
		3. [./short_ver/lyrics_99_bottles_of_beer.html Submission 9 August 2016]
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

	make
			--
		local
			short_ver: THE_SHORT_99_BOTTLES_OF_BEER_APPLICATION; short_ver_2016: LYRICS_99_BOTTLES_OF_BEER
			long_ver: THE_99_BOTTLES_OF_BEER_APPLICATION
			input_string: STRING
		do
			io.put_string ("1. Short version")
			io.put_new_line
			io.put_string ("2. Short 2016 version")
			io.put_new_line
			io.put_string ("3. Long version")
			io.put_new_line
			io.put_string ("Enter application number: (or return to quit) ")
			io.read_line
			input_string := io.last_string
			if input_string.is_integer and then
				input_string.to_integer >= 1 and input_string.to_integer <= 3
			then
				inspect input_string.to_integer
					when 1 then
						create short_ver.make

					when 2 then
						create short_ver_2016.make

					when 3 then
						create long_ver.make

				end
			end
		end

end
