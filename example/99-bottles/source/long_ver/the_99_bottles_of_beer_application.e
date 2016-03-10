indexing
	description: "[
		Application to generate lyrics for the song 99 Bottles of Beer
		See: http://www.99-bottles-of-beer.net/language-eiffel-231.html
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	THE_99_BOTTLES_OF_BEER_APPLICATION

inherit
	ANY
		redefine
			io
		end

create
	make

feature {NONE} -- Initialization

	make is
			-- Run application.
		local
			lyrics: SONG_LYRICS
			bottle_count: INTEGER
		do
			print ("Lyrics of the song " + Max_bottles.out + " Bottles of Beer")
			io.put_new_line
			io.put_new_line

			create lyrics.make

			from
				bottle_count := Max_bottles
			invariant
				is_true: bottle_count + lyrics.verse_count = Max_bottles

			until bottle_count < 0 loop
				lyrics.new_verse

				lyrics.append_long_status_clause (bottle_count)
				lyrics.append_status_clause (bottle_count)
				lyrics.new_sentence

				bottle_count := bottle_count - 1

				if bottle_count < 0 then
					lyrics.append_go_to_the_store_clause
					lyrics.append_long_status_clause (Max_bottles)
				else
					lyrics.append_take_one_down_clause
					lyrics.append_long_status_clause (bottle_count)
				end
			end

			lyrics.print_to_medium (output)
		end

feature {NONE} -- Implementation

	io: STD_FILES is
			--
		once
			create Result
		end

	output: PLAIN_TEXT_FILE is
			--
		once
			if {console: PLAIN_TEXT_FILE} io.output then
				Result := console
			else
				create Result.make ("output")
			end
		end

feature {NONE} -- Constants

	Max_bottles: INTEGER is 99

end -- class APPLICATION
