note
	description: "Remove all ufids task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:24:09 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	REMOVE_ALL_UFIDS_TASK

inherit
	MANAGEMENT_TASK

create
	make

feature -- Basic operations

	apply
			--
		do
			log.enter ("apply")
			Database.for_all_songs (not song_is_hidden, agent Database.remove_ufid)
			Database.store_all
			log.exit
		end

end
