note
	description: "Test simple server"
	notes: "[
		Option: -simple_server_test
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 10:43:12 GMT (Sunday 12th January 2020)"
	revision: "8"

class
	SIMPLE_SERVER_THREAD

inherit
	EL_LOGGED_IDENTIFIED_THREAD
		rename
			make_default as make
		end

create
	make

feature -- Basic operations

	execute
		local
			server: EL_SIMPLE_SERVER [SIMPLE_COMMAND_HANDLER]
		do
			log.enter ("execute")
			create server.make_local (8000)
			server.do_service_loop
			log.exit
		end

end
