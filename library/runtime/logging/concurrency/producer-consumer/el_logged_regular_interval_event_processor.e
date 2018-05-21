note
	description: "Logged regular interval event processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_LOGGED_REGULAR_INTERVAL_EVENT_PROCESSOR

inherit
	EL_REGULAR_INTERVAL_EVENT_PROCESSOR
		rename
			make_event_producer as make_unlogged_event_producer,
			make_bounded_loop_event_producer as make_unlogged_bounded_loop_event_producer
		redefine
			initialize_processor, regular_event_producer
		end

create
	make_event_producer, make_bounded_loop_event_producer

feature {NONE} -- Initialization

	make_event_producer (
		a_producer_name: like producer_name; consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER; interval: INTEGER
	)
			--
		do
			producer_name := a_producer_name
			make_unlogged_event_producer (consumer, interval)
		end

	make_bounded_loop_event_producer (
		a_producer_name: like producer_name
		consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER; interval, upper_count: INTEGER
	)
			--
		do
			producer_name := a_producer_name
			make_unlogged_bounded_loop_event_producer (consumer, interval, upper_count)
		end

feature {NONE} -- Implementation

	initialize_processor (consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER)
			--
		do
			regular_event_producer.set_name (producer_name)
			Precursor (consumer)
		end

feature {NONE} -- Internal attributes

	producer_name: STRING

feature {NONE} -- Internal attributes

	regular_event_producer: EL_LOGGED_REGULAR_INTERVAL_EVENT_PRODUCER

end