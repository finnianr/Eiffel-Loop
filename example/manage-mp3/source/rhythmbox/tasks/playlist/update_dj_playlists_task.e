note
	description: "[
		Update dj playlists tasks. Inserts an ignored entry into database indicating location of Pyxis playlist.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-30 8:03:55 GMT (Monday 30th March 2020)"
	revision: "4"

class
	UPDATE_DJ_PLAYLISTS_TASK

inherit
	RBOX_MANAGEMENT_TASK

create
	make

feature -- Basic operations

	apply
		do
			log.enter ("apply")
			Database.update_dj_playlists (dj_events.dj_name, dj_events.default_title)
			Database.store_all
			log.exit
		end

feature {NONE} -- Internal attributes

	dj_events: DJ_EVENT_INFO

end
