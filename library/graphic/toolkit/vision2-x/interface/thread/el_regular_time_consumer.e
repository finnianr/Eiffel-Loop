note
	description: "[
		Object that checks at timed intervals if a thread product is available and calls an agent to process it.
		The product is processed in the main GUI thread.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

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

	make_with_interval_and_action (an_interval: INTEGER; a_consumption_action: PROCEDURE [ANY, TUPLE [P]])
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

	consumption_action: PROCEDURE [ANY, TUPLE [P]]

end

