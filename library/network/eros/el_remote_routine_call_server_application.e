note
	description: "Summary description for {EL_REMOTE_ROUTINE_CALL_SERVER_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

deferred class
	EL_REMOTE_ROUTINE_CALL_SERVER_APPLICATION

inherit
	EL_SUB_APPLICATION

feature {NONE} -- Initialization

	initialize
			--
		do
			create port_number
			create request_handler_count_max
			Args.set_integer_from_word_option ("port", agent port_number.set_item , Default_port_number)
			Args.set_integer_from_word_option ("max_threads", agent request_handler_count_max.set_item , Default_request_handler_count_max)
			create gui.make (name, port_number, request_handler_count_max)
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

	name: STRING
			--

		deferred
		end

	gui: EL_REMOTE_ROUTINE_CALL_SERVER_UI

feature {NONE} -- Remotely callable types

	callable_classes: TUPLE
			--
		deferred
		end

	port_number, request_handler_count_max: INTEGER_REF

feature {NONE} -- Constants

	Default_request_handler_count_max: INTEGER = 30

	Default_port_number: INTEGER = 8001

end
