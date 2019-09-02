note
	description: "Export music to device test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 18:14:24 GMT (Monday 2nd September 2019)"
	revision: "2"

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
		undefine
			make_default
		end

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

				Database.songs.do_query (not song_is_hidden and song_is_genre ("Classical"))
				Database.songs.last_query_items.do_all (agent {RBOX_SONG}.hide)

				log.put_line ("Changing titles on Rock Songs")
				Database.songs.do_query (not song_is_hidden and song_is_genre ("Rock"))
				across Database.songs.last_query_items as song loop
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
