note
	description: "EROS server testing thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 11:41:19 GMT (Tuesday 8th February 2022)"
	revision: "3"

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