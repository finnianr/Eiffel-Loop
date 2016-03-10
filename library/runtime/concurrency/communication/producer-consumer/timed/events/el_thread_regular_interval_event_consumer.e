note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER

inherit
	EL_REGULAR_INTERVAL_EVENT_CONSUMER
		undefine
			is_equal, copy, stop
		redefine
			make_default
		end

	EL_CONSUMER_THREAD [EL_REGULAR_INTERVAL_EVENT]
		rename
			product as event,
			consume_product as process_event
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REGULAR_INTERVAL_EVENT_CONSUMER}
			Precursor {EL_CONSUMER_THREAD}
		end
end
