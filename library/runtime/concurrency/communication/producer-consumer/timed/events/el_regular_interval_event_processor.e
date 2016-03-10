note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_REGULAR_INTERVAL_EVENT_PROCESSOR

inherit
	EL_SHARED_THREAD_MANAGER

	EL_THREAD_DEVELOPER_CLASS

create
	make_event_producer, make_bounded_loop_event_producer

feature {NONE} -- Initialization

	make_event_producer (consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER; name: STRING; interval: INTEGER)
			--
		do
			create regular_event_producer.make_with_interval (interval)
			initialize_processor (consumer, name)
		end

	make_bounded_loop_event_producer (
		consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER; name: STRING; interval, upper_count: INTEGER
	)
			--
		do
			create regular_event_producer.make_with_interval_and_upper_count (interval, upper_count)
			initialize_processor (consumer, name)
		end

	initialize_processor (consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER; name: STRING)
			--
		do
			thread_manager.extend (regular_event_producer)
			regular_event_producer.set_consumer (consumer)
			regular_event_producer.set_log_name (name)
			regular_event_producer.launch
			consumer.launch
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

	regular_event_producer: EL_REGULAR_INTERVAL_EVENT_PRODUCER

end
