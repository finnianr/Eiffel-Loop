note
	description: "Remote routine call server application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 9:34:29 GMT (Monday 20th January 2020)"
	revision: "9"

deferred class
	EROS_REMOTE_ROUTINE_CALL_SERVER_APPLICATION

inherit
	EL_LOGGED_SUB_APPLICATION
		undefine
			Application_option
		end

	EROS_SHARED_APPLICATION_OPTIONS

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make (name, Application_option.port, Application_option.max_threads)
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

	name: ZSTRING
			--

		deferred
		end

	gui: EROS_REMOTE_ROUTINE_CALL_SERVER_UI

feature {NONE} -- Remotely callable types

	callable_classes: TUPLE
			-- remotely callable types tuple
		deferred
		ensure
			all_remotely_accessible: all_remotely_accessible (Result)
		end

	all_remotely_accessible (tuple: TUPLE): BOOLEAN
		local
			list: EL_TUPLE_TYPE_LIST [EROS_REMOTELY_ACCESSIBLE]
		do
			create list.make_from_tuple (tuple)
			Result := list.count = tuple.count
		end

end
