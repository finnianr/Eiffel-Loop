note
	description: "Agent event listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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