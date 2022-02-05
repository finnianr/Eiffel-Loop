note
	description: "Remote routine call server application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 17:37:14 GMT (Saturday 5th February 2022)"
	revision: "10"

deferred class
	EROS_REMOTE_ROUTINE_CALL_SERVER_APPLICATION

inherit
	EL_LOGGED_APPLICATION
		undefine
			new_command_options
		end

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make (name, Option.port, Option.max_threads)
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

feature {NONE} -- Implementation

	name: ZSTRING
			--

		deferred
		end

	new_command_options: like Option
		do
			Result := Option
		end

feature {NONE} -- Internal attributes

	gui: EROS_REMOTE_ROUTINE_CALL_SERVER_UI

feature {NONE} -- Remotely callable types

	all_remotely_accessible (tuple: TUPLE): BOOLEAN
		local
			list: EL_TUPLE_TYPE_LIST [EROS_REMOTELY_ACCESSIBLE]
		do
			create list.make_from_tuple (tuple)
			Result := list.count = tuple.count
		end

	callable_classes: TUPLE
			-- remotely callable types tuple
		deferred
		ensure
			all_remotely_accessible: all_remotely_accessible (Result)
		end

feature {NONE} -- Constants

	Option: EROS_APPLICATION_OPTIONS
		once
			create Result.make
		end

end