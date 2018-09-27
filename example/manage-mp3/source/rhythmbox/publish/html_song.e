note
	description: "Html song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	HTML_SONG

inherit
	EVOLICITY_EIFFEL_CONTEXT
		redefine
			getter_function_table
		end

	RHYTHMBOX_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_song: like song; a_start_time: like start_time; a_tanda_type: like tanda_type)
		do
			make_default
			song := a_song; start_time := a_start_time; tanda_type := a_tanda_type
			artists := song.lead_artist.twin
			if song.artists_list.count > 1 then
				if song.album_artists_prefix.as_lower.starts_with_general ("singer") then
					artists.append_string_general (" with vocalist")
					if song.album_artists_list.count > 1 then
						artists.append_string_general ("s: ")
					else
						artists.append_string_general (": ")
					end
					across song.album_artists_list as artist loop
						if artist.cursor_index > 1 then
							artists.append_string_general (", ")
						end
						artists.append (artist.item)
					end
				else
					artists.append_string_general (" and ")
					artists.append (song.album_artist)
				end
			end
		end

feature -- Access

	song: RBOX_SONG

	start_time: TIME

	tanda_type: ZSTRING

	artists: ZSTRING

feature -- Status query

	is_final_cortina: BOOLEAN
		do
			Result := tanda_type ~ Tanda_type_the_end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["song", 				agent: like song do Result := song end],
				["start_time", 		agent: STRING do Result := start_time.formatted_out (once "[0]hh:[0]mi") end],
				["tanda_type", 		agent: ZSTRING do Result := tanda_type end],
				["artists", 			agent: ZSTRING do Result := artists end],
				["is_final_cortina", agent: BOOLEAN_REF do Result := is_final_cortina.to_reference end]
			>>)
		end

end