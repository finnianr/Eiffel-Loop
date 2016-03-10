note
	description: "Summary description for {M3U_PLAYLIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M3U_PLAYLIST

inherit
	EVOLICITY_SERIALIZEABLE

create
	make

feature {NONE} -- Initialization

	make (a_playlist: ARRAYED_LIST [RBOX_SONG]; a_playlist_root: like playlist_root; a_output_path: like output_path)
		local
			tando_index: INTEGER
		do
			playlist_root := a_playlist_root
			create playlist.make (a_playlist.count)
			across a_playlist as song loop
				if song.item.is_cortina then
					tando_index := tando_index + 1
				end
				playlist.extend (new_song_context (song.item, tando_index))
			end
			make_from_file (a_output_path)
		end

feature {NONE} -- Implementation

	new_song_context (song: RBOX_SONG; tando_index: INTEGER): EVOLICITY_CONTEXT_IMPL
		local
			artists, song_info, tanda_name: ASTRING
		do
 			artists := song.lead_artist.twin
 			if not song.album_artists_list.is_empty then
 				artists.append_string (" (")
 				artists.append (song.album_artists)
 				artists.append_character (')')
 			end
			create Result.make
			if song.is_cortina then
				tanda_name := song.title.twin
				tanda_name.remove_head (3)
				tanda_name.prune_all_trailing (tanda_name [tanda_name.count])
				tanda_name.right_adjust
				song_info := Song_info_template #$ [song.duration, tanda_name, Double_digits.formatted (tando_index)]
			else
				song_info := Song_info_template #$ [song.duration, song.title, artists]
			end
			Result.put_variable (song_info, Var_song_info)
			Result.put_variable (relative_path (song), Var_relative_path)
		end

	relative_path (song: RBOX_SONG): EL_FILE_PATH
		do
			Result := song.mp3_relative_ntfs_path
		end

feature {NONE} -- Attributes

	playlist_root: ASTRING

 	playlist: ARRAYED_LIST [like new_song_context]

feature {NONE} -- Evolicity fields

	Template: STRING
		once
			Result := "[
				#EXTM3U
				#across $playlist as $song loop
				#EXTINF: $song.item.song_info
				$playlist_root/Music/$song.item.relative_path
				#end
			]"
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["playlist", 		agent: like playlist do Result := playlist end],
				["playlist_root", agent: like playlist_root do Result := playlist_root end]
			>>)
		end

feature {NONE} -- Constants

	Song_info_template: ASTRING
		once
			Result := "$S, $S -- $S"
		end

	Var_relative_path: ASTRING
		once
			Result := "relative_path"
		end
	Var_song_info: ASTRING
		once
			Result := "song_info"
		end

	Double_digits: FORMAT_INTEGER
		once
			create Result.make (2)
			Result.zero_fill
		end

end
