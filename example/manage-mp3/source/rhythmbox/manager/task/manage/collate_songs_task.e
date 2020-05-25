note
	description: "Collate songs task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-25 16:04:11 GMT (Monday 25th May 2020)"
	revision: "8"

class
	COLLATE_SONGS_TASK

inherit
	RBOX_MANAGEMENT_TASK

	DATABASE_UPDATE_TASK

create
	make

feature -- Basic operations

	apply
		-- sort mp3 files into directories according to genre and artist set in Rhythmbox music library Database.
		-- Playlist locations will be updated to match new locations.
		local
			new_mp3_path: EL_FILE_PATH; song: RBOX_SONG
		do
			Database.songs.do_query (not one_of (<< song_is_hidden, song_is_cortina, song_has_normalized_mp3_path >>))
			if Database.songs.last_query_items.is_empty then
				lio.put_line ("All songs are normalized")
			else
				across Database.songs.last_query_items as query loop
					song := query.item
					new_mp3_path := song.unique_normalized_mp3_path
					lio.put_labeled_string ("Old path", song.mp3_relative_path)
					lio.put_new_line
					lio.put_labeled_string ("New path", new_mp3_path.relative_path (Database.music_dir))
					lio.put_new_line
					lio.put_new_line
					File_system.make_directory (new_mp3_path.parent)
					OS.move_file (song.mp3_path, new_mp3_path)
					if song.mp3_path.parent.exists then
						File_system.delete_empty_branch (song.mp3_path.parent)
					end
					Database.songs_by_location.replace_key (new_mp3_path, song.mp3_uri)
					song.set_mp3_path (new_mp3_path)
				end
				Database.store_all
				File_system.make_directory (Database.music_dir.joined_dir_path ("Additions"))
			end
		end

end
