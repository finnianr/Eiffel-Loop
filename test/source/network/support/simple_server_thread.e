note
	description: "Test simple server thread"
	notes: "[
		Also used to prove that type references like {SIMPLE_COMMAND_HANDLER} 
		always return the same object regardless of the thread process that
		referenced them.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-06 10:12:38 GMT (Sunday 6th October 2024)"
	revision: "11"

class
	SIMPLE_SERVER_THREAD

inherit
	EL_LOGGED_IDENTIFIED_THREAD

create
	make

feature {NONE} -- Initialization

	make (a_type: like type)
		do
			type := a_type
			make_default
		end

feature -- Status query

	same_type_object: BOOLEAN

feature -- Basic operations

	execute
		local
			server: EL_SIMPLE_SERVER [SIMPLE_COMMAND_HANDLER]
		do
			log.enter ("execute")
			same_type_object := type = {SIMPLE_COMMAND_HANDLER}
			create server.make_local (8000)
			server.do_service_loop
			log.exit
		end

feature {NONE} -- Internal attributes

	type: TYPE [ANY]
end