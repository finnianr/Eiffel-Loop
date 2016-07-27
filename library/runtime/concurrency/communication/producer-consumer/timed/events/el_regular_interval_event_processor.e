note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-02 10:01:27 GMT (Saturday 2nd July 2016)"
	revision: "3"

class
	EL_REGULAR_INTERVAL_EVENT_PROCESSOR

inherit
	EL_SHARED_THREAD_MANAGER

	EL_THREAD_DEVELOPER_CLASS

create
	make_event_producer, make_bounded_loop_event_producer

feature {NONE} -- Initialization

	make_bounded_loop_event_producer (consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER; interval, upper_count: INTEGER)
			--
		do
			create regular_event_producer.make_with_interval_and_upper_count (interval, upper_count)
			initialize_processor (consumer)
		end

	make_event_producer (consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER; interval: INTEGER)
			--
		do
			create regular_event_producer.make_with_interval (interval)
			initialize_processor (consumer)
		end

feature -- Basic operations

	start
			--
		do
			regular_event_producer.start
		end

	stop
			--
		do
			regular_event_producer.stop
		end

feature {NONE} -- Implementation

	initialize_processor (consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER)
			--
		do
			thread_manager.extend (regular_event_producer)
			regular_event_producer.set_consumer (consumer)
			regular_event_producer.launch
			consumer.launch
		end

feature {NONE} -- Internal attributes

	regular_event_producer: EL_REGULAR_INTERVAL_EVENT_PRODUCER

end