note
	description: "Export music to device task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 18:09:53 GMT (Monday 2nd September 2019)"
	revision: "2"

class
	EXPORT_MUSIC_TO_DEVICE_TASK

inherit
	EXPORT_TO_DEVICE_TASK
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			create selected_genres.make (10)
			Precursor
		end

feature -- Access

	selected_genres: EL_ZSTRING_LIST

feature -- Status query

	is_full_export_task: BOOLEAN
		do
			Result := selected_genres.is_empty
		end

feature -- Basic operations

	apply
		local
			device: like new_device
		do
			log.enter ("apply")
			device := new_device
			if device.volume.is_valid then
				if selected_genres.is_empty then
					device.export_songs_and_playlists (songs_all)
				else
					across selected_genres as genre loop
						if Database.is_valid_genre (genre.item) then
							lio.put_string_field ("Genre " + genre.cursor_index.out, genre.item)
						else
							lio.put_string_field ("Invalid genre", genre.item)
						end
						lio.put_new_line
					end
					export_to_device (
						device, song_in_some_playlist (Database) or song_one_of_genres (selected_genres),
						Database.case_insensitive_name_clashes
					)
				end
			else
				notify_invalid_volume
			end
			log.exit
		end

feature {NONE} -- Implementation

	export_to_device (
		device: like new_device; a_condition: EL_QUERY_CONDITION [RBOX_SONG]; name_clashes: LINKED_LIST [EL_FILE_PATH]
	)
		do
			if name_clashes.is_empty then
				device.export_songs_and_playlists (a_condition)
			else
				-- A problem on NTFS and FAT32 filesystems
				lio.put_line ("CASE INSENSITIVE NAME CLASHES FOUND")
				lio.put_new_line
				across name_clashes as path loop
					lio.put_path_field ("MP3", path.item)
					lio.put_new_line
				end
				lio.put_new_line
				lio.put_line ("Fix before proceeding")
			end
		end

	notify_invalid_volume
		do
			lio.put_labeled_string ("Volume not mounted", volume.name)
			lio.put_new_line
		end

end
