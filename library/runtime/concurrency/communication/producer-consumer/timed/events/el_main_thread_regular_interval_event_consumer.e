note
	description: "Main thread regular interval event consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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