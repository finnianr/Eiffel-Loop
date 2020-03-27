note
	description: "Export music to device test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-27 8:59:37 GMT (Friday 27th March 2020)"
	revision: "4"

class
	EXPORT_MUSIC_TO_DEVICE_TEST_TASK

inherit
	EXPORT_MUSIC_TO_DEVICE_TASK
		undefine
			root_node_name, new_device
		redefine
			apply
		end

	EXPORT_TO_DEVICE_TEST_TASK

create
	make

feature -- Basic operations

	apply
		local
			title: ZSTRING
		do
			Precursor
			-- Do it again
			if selected_genres.is_empty then
				log.put_line ("Hiding Classical songs")

				across Database.songs.query (not song_is_hidden and song_is_genre ("Classical")) as song loop
					song.item.hide
				end

				log.put_line ("Changing titles on Rock Songs")

				across Database.songs.query (not song_is_hidden and song_is_genre ("Rock")) as song loop
					title := song.item.title
					title.prepend_character ('X')
					song.item.set_title (title)
					song.item.update_checksum
				end
			else
				log.put_line ("Removing genre: Irish Traditional")
				selected_genres.prune ("Irish Traditional")
			end
			Precursor
		end

end
