note
	description: "[
		Object that checks at timed intervals if a thread product is available and calls an agent to process it.
		The product is processed in the main GUI thread.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_REGULAR_TIME_CONSUMER [P]

inherit
	EL_CONSUMER_MAIN_THREAD [P]
		undefine
			copy, default_create
		redefine
			prompt
		end

	EV_TIMEOUT
		export
			{NONE} all
		end

create
	make_with_interval_and_action

feature {NONE} -- Initialization

	make_with_interval_and_action (an_interval: INTEGER; a_consumption_action: PROCEDURE [P])
			-- Create with `an_interval' in milliseconds.
		do
			make_with_interval (an_interval)
			actions.extend (agent consume_product)
			consumption_action := a_consumption_action
		end

feature -- Basic operations

	prompt
			-- do nothing
		do
		end

feature {NONE} -- Implementation

	consume_product
			--
		do
			consumption_action.call ([product])
		end

	consumption_action: PROCEDURE [P]

end