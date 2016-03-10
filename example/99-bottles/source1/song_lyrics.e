indexing
	description: "Lyrics of the song 99 Bottles of Beer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	SONG_LYRICS

inherit
	LINKED_LIST [VERSE]
		rename
			make as make_list,
			count as verse_count,
			last as	last_verse
		end

create
	make

feature -- Initialization

	make is
			--
		do
			make_list
		end

feature -- Element change

	append_long_status_clause (bottle_count: INTEGER) is
			--
		local
			long_status: LONG_BOTTLE_STATUS_CLAUSE
		do
			long_status := bottle_count
			append_to_last_sentence (long_status)
		end

	append_status_clause (bottle_count: INTEGER) is
			--
		local
			status: BOTTLE_STATUS_CLAUSE
		do
			status := bottle_count
			append_to_last_sentence (status)
		end

	append_go_to_the_store_clause is

		do
			append_to_last_sentence ("Go to the store and buy some more")
		end

	append_take_one_down_clause is

		do
			append_to_last_sentence ("Take one down and pass it around")
		end

	append_to_last_sentence (clause: CLAUSE) is

		do
			if last_verse.last_sentence.is_empty then
				clause.capitalize_first
			end
			last_verse.last_sentence.extend (clause)
		end

feature -- Access

	new_verse is

		do
			extend (create {VERSE}.make)
			new_sentence
		end

	new_sentence is

		do
			last_verse.extend (create {SENTENCE}.make)
		end

feature -- Output		

	print_to_medium (io_medium: IO_MEDIUM) is
			--

		do
			do_all (agent {VERSE}.print_to_medium (io_medium))
		end

end -- class SONG_LYRICS
