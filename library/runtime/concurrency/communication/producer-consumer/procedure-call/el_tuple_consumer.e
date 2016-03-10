note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-23 13:20:16 GMT (Thursday 23rd April 2015)"
	revision: "2"

deferred class
	EL_TUPLE_CONSUMER  [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

feature {NONE} -- Initialization

	make_default
			--
		do
			create actions
		end

feature -- Access

	actions: ACTION_SEQUENCE [OPEN_ARGS]

	action: PROCEDURE [BASE_TYPE, OPEN_ARGS]

feature -- Element change

	set_action (an_action: like action)
			--
		do
			action := an_action
		end

feature {NONE} -- Implementation

	consume_tuple
			--
		do
			if not actions.is_empty then
				actions.call (tuple)
			end
			if attached action as procedure then
				procedure.call (tuple)
			end
		end

	tuple: OPEN_ARGS
			--
		deferred
		end

end
