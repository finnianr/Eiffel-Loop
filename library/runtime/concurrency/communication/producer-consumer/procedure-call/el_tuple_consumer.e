note
	description: "Tuple consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_TUPLE_CONSUMER  [OPEN_ARGS -> TUPLE create default_create end]

feature {NONE} -- Initialization

	make_default
			--
		do
			create actions
		end

feature -- Access

	actions: ACTION_SEQUENCE [OPEN_ARGS]

	action: PROCEDURE [OPEN_ARGS]

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
