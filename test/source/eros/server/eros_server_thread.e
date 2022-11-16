note
	description: "EROS server testing thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EROS_SERVER_THREAD [TYPES -> TUPLE create default_create end]

inherit
	EL_LOGGED_IDENTIFIED_THREAD

	EROS_SERVER_COMMAND [TYPES]
		redefine
			make, serve
		end

create
	make

feature {NONE} -- Initialization

	make (port: INTEGER)
		do
			make_default
			Precursor (port)
		end

feature -- Constants

	Description: STRING = "EROS server testing thread"

feature {NONE} -- Implementation

	serve (client: EL_STREAM_SOCKET)
			--
		do
			Precursor (client)
			done := handler.is_stopped
		end
end