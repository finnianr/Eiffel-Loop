note
	description: "[
		Import mp3 not currently in database and set artist and genre according to current location in

			Music/<genre>/<artist/composer>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-09 9:54:56 GMT (Monday 9th January 2023)"
	revision: "11"

class
	IMPORT_NEW_MP3_TASK

inherit
	RBOX_MANAGEMENT_TASK

	DATABASE_UPDATE_TASK

	EL_MODULE_OS

create
	make

feature -- Basic operations

	apply
		local
			new_mp3_list: LINKED_LIST [FILE_PATH]
			song: RBOX_SONG
		do
			create new_mp3_list.make
			across OS.file_list (Database.music_dir, "*.mp3") as mp3_path loop
				if not Database.songs_by_location.has (mp3_path.item) then
					new_mp3_list.extend (mp3_path.item)
				end
			end
			if not new_mp3_list.is_empty then
				lio.put_line ("Importing new MP3")
				lio.put_new_line
				across new_mp3_list as mp3_path loop
					song := Database.new_song
					set_fields (song, mp3_path.item)
					song.move_mp3_to_normalized_file_path
					Database.extend (song)
					lio.put_path_field ("Imported %S", song.mp3_relative_path)
					lio.put_new_line
				end
				Database.store_all
			else
				lio.put_line ("Nothing to import")
			end
		end

feature {NONE} -- Implementation

	set_fields (song: RBOX_SONG; mp3_path: FILE_PATH)
		require
			not_already_present: not Database.songs_by_location.has (mp3_path)
		local
			relative_steps: EL_PATH_STEPS; id3_info: TL_MUSICBRAINZ_MPEG_FILE
		do
			relative_steps := mp3_path.relative_path (music_dir)
			if relative_steps.count = 3 then
				create id3_info.make (mp3_path)
				if id3_info.tag.title.is_empty then
					song.set_title (mp3_path.base_name)
				else
					song.set_title (id3_info.tag.title)
				end
				song.set_duration (id3_info.tag.duration)
				song.set_album (id3_info.tag.album)
				song.set_track_number (id3_info.tag.track)
				song.set_recording_year (id3_info.tag.year)

				song.set_genre (relative_steps [1])
				song.set_artist (relative_steps [2])
				song.set_mp3_path (mp3_path)

				song.write_id3_info (id3_info)
				id3_info.dispose
				song.update_file_info
			end
		end

end