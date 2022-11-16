note
	description: "Regular interval event producer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_REGULAR_INTERVAL_EVENT_PRODUCER

inherit
	EL_DORMANT_ACTION_LOOP_THREAD
		rename
			stop as stop_thread,
			do_action as sleep_then_post_event,
			suspend as stop,
			resume as start
		redefine
			on_resumption, on_suspension
		end

	EL_SHARED_THREAD_MANAGER

create
	make_with_interval, make_with_interval_and_upper_count

feature {NONE} -- Initialization

	make_with_interval (an_interval: INTEGER)
			-- Create with `an_interval' in milliseconds.
			-- Infinite loop

		require
			an_interval_not_negative: an_interval >= 0
		do
			make_default
			interval := an_interval
			create event_queue.make (10)
			is_bounded_loop := false
		end

	make_with_interval_and_upper_count (an_interval, an_upper_count: INTEGER)
			-- Create with `an_interval' in milliseconds.
			-- Bounded loop

		require
			an_upper_count_greater_than_zero: an_upper_count > 0
		do
			make_with_interval (an_interval)
			upper_count := an_upper_count
			is_bounded_loop := true
		end

feature -- Access

	count: INTEGER

	upper_count: INTEGER

feature -- Element change

	set_consumer (a_consumer: like consumer)
			--
		require
			not_active: is_stopped or is_suspended
		do
			consumer := a_consumer
			event_queue.attach_consumer (consumer)
		end

	set_interval (an_interval: like interval)
			--
		require
			is_stopped: is_stopped
		do
			interval := an_interval
		end

	set_upper_count  (an_upper_count : like upper_count )
			--
		require
			is_stopped: is_stopped
		do
			upper_count  := an_upper_count
		end

feature -- Status query

	is_bounded_loop: BOOLEAN

	is_valid_consumer: BOOLEAN
			--
		do
			Result := consumer /= Void
		end

feature {NONE} -- Event handling

	on_event_posted
		do
		end

	on_resumption
			--
		do
			event_queue.put (create {EL_REGULAR_INTERVAL_EVENT}.make_delimiter_start)
			elapsed_millisecs := 0
			count := 1
		end

	on_suspension
			--
		do
			event_queue.put (create {EL_REGULAR_INTERVAL_EVENT}.make_delimiter_end)
		end

feature {NONE} -- Implemenation

	sleep_then_post_event
			--
		local
			event: EL_REGULAR_INTERVAL_EVENT
		do
			sleep (interval)
			if not (is_stopping or is_suspending) then
				elapsed_millisecs := elapsed_millisecs + interval
				create event.make (elapsed_millisecs, count)
				event_queue.put (event)
				count := count + 1
				on_event_posted

				if is_bounded_loop and count > upper_count then
					stop
				end
			end
		end

	interval: INTEGER

	elapsed_millisecs: INTEGER

	event_queue: EL_THREAD_PRODUCT_QUEUE [EL_REGULAR_INTERVAL_EVENT]

	consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER

end