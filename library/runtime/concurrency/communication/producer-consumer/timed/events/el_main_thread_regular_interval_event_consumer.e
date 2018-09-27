note
	description: "Main thread regular interval event consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER

inherit
	EL_REGULAR_INTERVAL_EVENT_CONSUMER
		undefine
			stop
		end
		
	EL_CONSUMER_MAIN_THREAD [EL_REGULAR_INTERVAL_EVENT]
		rename
			product as event,
			consume_product as process_event
		end

end