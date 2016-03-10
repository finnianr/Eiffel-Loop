note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_TUPLE_CONSUMER  [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

feature {NONE} -- Initialization

	make
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
