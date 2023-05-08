note
	description: "Export music to device task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-08 11:11:07 GMT (Monday 8th May 2023)"
	revision: "8"

class
	EXPORT_MUSIC_TO_DEVICE_TASK

inherit
	EXPORT_TO_DEVICE_TASK

create
	make

feature -- Access

	selected_genres: EL_ZSTRING_LIST

feature -- Status query

	is_full_export_task: BOOLEAN
		do
			Result := selected_genres.is_empty
		end

feature -- Basic operations

	apply
		do
			if selected_genres.is_empty then
				device.export_songs_and_playlists (any_song)
			else
				across selected_genres as genre loop
					if Database.is_valid_genre (genre.item) then
						lio.put_index_labeled_string (genre, "Genre [%S]", genre.item)
					else
						lio.put_string_field ("Invalid genre", genre.item)
					end
					lio.put_new_line
				end
				export_to_device (
					song_in_some_playlist (Database) or song_one_of_genres (selected_genres),
					Database.case_insensitive_name_clashes
				)
			end
		end

end