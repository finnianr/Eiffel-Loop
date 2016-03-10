note
	description: "Summary description for {RBOX_FINNIANS_DATABASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RBOX_FINNIANS_DATABASE

inherit
	RBOX_DATABASE

create
	make

feature -- Basic operations

	normalize_artist_and_title_fields
			--
		local
			l_song: RBOX_SONG
		do
			songs.set_default_criteria
			across songs.query_results as song loop
				l_song := song.item
				if l_song.album.as_lower.starts_with ("awards for world music") then
					Title_editor_for_album_Awards_For_World_Music.edit (l_song.title)
					if Title_editor_for_album_Awards_For_World_Music.full_match_succeeded then
						l_song.set_artist (
							Title_editor_for_album_Awards_For_World_Music.artist_from_title
							 + " (" + Title_editor_for_album_Awards_For_World_Music.country_from_title + ")"
						)
					end
				elseif l_song.genre.starts_with ("Classical") then
					Classical_title_field_editor.edit (l_song.title)
					l_song.artists_list.do_all (agent Field_editor.edit)
				else
					Title_field_editor.edit (l_song.title)
					if l_song.recording_date = 0 and then Title_field_editor.recording_date_from_title /= 0 then
						l_song.set_recording_date (Title_field_editor.recording_date_from_title)
					end
					l_song.artists_list.do_all (agent Field_editor.edit)
				end
			end
		end

--	normalized_artists: EL_ASTRING
--			--
--		do
--			Result := artists_list.comma_separated
--			Field_editor.edit (Result)
--		end

--	normalized_title: EL_ASTRING
--			--
--		do
--			Result := title.out
--			if genre.starts_with ("Classical") then
--				Classical_title_field_editor.edit (Result)
--			else
--				Title_field_editor.edit (Result)
--			end
--		end

feature {NONE} -- Constants

	Field_editor: ID3_LATIN1_FIELD_EDITOR
			--
		once
			create Result.make
		end

	Title_field_editor: ID3_LATIN1_TITLE_FIELD_EDITOR
			--
		once
			create Result.make
		end

	Classical_title_field_editor: ID3_LATIN1_CLASSICAL_TITLE_FIELD_EDITOR
			--
		once
			create Result.make
		end

	Title_editor_for_album_Awards_For_World_Music: AWARDS_FOR_WORLD_MUSIC_TITLE_EDITOR
			--
		once
			create Result.make
		end

end
