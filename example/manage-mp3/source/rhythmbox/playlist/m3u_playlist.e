note
	description: "Summary description for {M3U_PLAYLIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 9:18:42 GMT (Friday 24th June 2016)"
	revision: "4"

class
	M3U_PLAYLIST

inherit
	EVOLICITY_SERIALIZEABLE

create
	make

feature {NONE} -- Initialization

	make (
		a_playlist: ARRAYED_LIST [RBOX_SONG]; a_playlist_root: like playlist_root
		a_is_windows_format: like is_windows_format; a_output_path: like output_path
	)
		local
			tando_index: INTEGER
		do
			playlist_root := a_playlist_root; is_windows_format := a_is_windows_format
			create playlist.make (a_playlist.count)
			across a_playlist as song loop
				if song.item.is_cortina then
					tando_index := tando_index + 1
				end
				playlist.extend (new_song_context (song.item, tando_index))
			end
			make_from_file (a_output_path)
		end

feature -- Status change

	is_windows_format: BOOLEAN

feature {NONE} -- Implementation

	new_song_context (song: RBOX_SONG; tando_index: INTEGER): EVOLICITY_CONTEXT_IMP
		local
			artists, song_info, tanda_name: ZSTRING
		do
 			artists := song.lead_artist.twin
 			if not song.album_artists_list.is_empty then
 				artists.append_string_general (" (")
 				artists.append (song.album_artist)
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
			Result := song.exported_relative_path (is_windows_format)
		end

feature {NONE} -- Attributes

	playlist_root: ZSTRING

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

	Double_digits: FORMAT_INTEGER
		once
			create Result.make (2)
			Result.zero_fill
		end

	Song_info_template: ZSTRING
		once
			Result := "%S, %S -- %S"
		end

	Var_relative_path: ZSTRING
		once
			Result := "relative_path"
		end
	Var_song_info: ZSTRING
		once
			Result := "song_info"
		end

end
