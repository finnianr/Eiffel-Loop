note
	description: "Agent event listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 10:23:15 GMT (Saturday 11th January 2020)"
	revision: "1"

class
	EL_AGENT_EVENT_LISTENER

inherit
	EL_EVENT_LISTENER

create
	make

convert
	make ({PROCEDURE})

feature {NONE} -- Initialization

	make (a_action: PROCEDURE)
		do
			action := a_action
		end

feature {NONE} -- Basic operations

	notify
		do
			action.apply
		end

feature {NONE} -- Internal attributes

	action: PROCEDURE

end
