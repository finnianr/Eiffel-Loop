note
	description: "Test variation of [$source ADD_ALBUM_ART_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-28 13:08:02 GMT (Saturday 28th March 2020)"
	revision: "1"

class
	ADD_ALBUM_ART_TEST_TASK

inherit
	ADD_ALBUM_ART_TASK
		undefine
			root_node_name
		redefine
			apply
		end

	TEST_MANAGEMENT_TASK
		undefine
			make
		end

feature -- Basic operations

	apply
		do
			Precursor
			log.enter ("update_pictures")
			update_pictures
			log.exit
		end

end
