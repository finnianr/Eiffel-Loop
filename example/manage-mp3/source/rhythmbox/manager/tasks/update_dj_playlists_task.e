note
	description: "Update dj playlists task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:25:57 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	UPDATE_DJ_PLAYLISTS_TASK

inherit
	MANAGEMENT_TASK

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
