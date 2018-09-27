note
	description: "Thread regular interval event consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER

inherit
	EL_REGULAR_INTERVAL_EVENT_CONSUMER
		undefine
			is_equal, copy, stop, name
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