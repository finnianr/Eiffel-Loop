note
	description: "Summary description for {MP3_GENRE_SONG_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	MP3_GENRE_SONG_SET

inherit
	LINKED_LIST [EVOLICITY_CONTEXT_IMPL]
		rename
			extend as extend_list
		redefine
			make
		end

	EVOLICITY_CONTEXT_IMPL
		rename
			make as make_context
		export
			{NONE} all
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_context
			Precursor
		end

feature -- Access

	last_genre: STRING

feature -- Element change

	extend (song: RBOX_SONG; formatted_time: STRING; song_was_played: BOOLEAN)
			--
		do
			extend_list (create {EVOLICITY_CONTEXT_IMPL}.make)
			last.put_variable (song, "song")
			last.put_variable (formatted_time, "start_time")
			last.put_variable (song_was_played.to_reference, "song_was_played")
			last_genre := song.genre_main
		end

end
