note
	description: "Eros server thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-21 16:57:46 GMT (Tuesday 21st January 2020)"
	revision: "2"

class
	EROS_SERVER_THREAD

inherit
	EL_LOGGED_IDENTIFIED_THREAD

	EROS_SERVER_COMMAND
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

feature {NONE} -- Implementation

	serve (client: EL_STREAM_SOCKET)
			--
		do
			Precursor (client)
			done := handler.is_stopped
		end
end
