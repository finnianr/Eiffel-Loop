note
	description: "Ecd notifying editions file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-13 19:35:00 GMT (Wednesday 13th February 2019)"
	revision: "1"

class
	ECD_NOTIFYING_EDITIONS_FILE [G -> EL_STORABLE create make_default end]

inherit
	ECD_EDITIONS_FILE [G]
		undefine
			notify, move, go, recede, back, start, finish, forth
		end

	EL_NOTIFYING_RAW_FILE
		rename
			make as make_file,
			count as file_count
		undefine
			delete
		end

create
	make

end
