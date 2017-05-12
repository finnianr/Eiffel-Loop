note
	description: "Summary description for {EL_LOGGED_REGULAR_INTERVAL_EVENT_PRODUCER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-19 9:35:51 GMT (Wednesday 19th April 2017)"
	revision: "3"

class
	EL_LOGGED_REGULAR_INTERVAL_EVENT_PRODUCER

inherit
	EL_REGULAR_INTERVAL_EVENT_PRODUCER
		rename
			on_event_posted as log_event
		undefine
			log_event
		redefine
			event_queue, on_start, on_resumption
		end

	EL_LOGGED_EVENT_COUNTER

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

create
	make_with_interval, make_with_interval_and_upper_count

feature {NONE} -- Event handling

	on_resumption
		do
			Precursor
			reset
		end

feature {NONE} -- Implementation

	on_start
		do
			Log_manager.add_thread (Current)
		end

feature {NONE} -- Internal attributes

	event_queue: EL_LOGGED_THREAD_PRODUCT_QUEUE [EL_REGULAR_INTERVAL_EVENT]

feature {NONE} -- Constants

	Count_label: ZSTRING
		once
			Result := "Timer events"
		end

end
