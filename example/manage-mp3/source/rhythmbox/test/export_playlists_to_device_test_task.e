note
	description: "Export playlists to device test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:32:02 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK

inherit
	EXPORT_PLAYLISTS_TO_DEVICE_TASK
		undefine
			root_node_name
		redefine
			apply
		end

	TEST_MANAGEMENT_TASK
		undefine
			make_default
		end

create
	make

feature -- Basic operations

	apply
		do
			Precursor
			-- and again
			log.put_line ("Removing first playlist")
				-- Expected behaviour is that it shouldn't delete anything
			Database.playlists.start
			Database.playlists.remove
			Precursor
		end

end
