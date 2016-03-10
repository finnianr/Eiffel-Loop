note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_REGULAR_INTERVAL_EVENT_PRODUCER

inherit
	EL_DORMANT_ACTION_LOOP_THREAD
		rename
			stop as stop_thread,
			do_action as post_event_after_a_little_sleep,
			suspend as stop,
			resume as start
		redefine
			on_resumption, on_suspension, is_visible_in_console, log_name
		end

	EL_SHARED_THREAD_MANAGER
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			default_create, is_equal, copy
		end

create
	make_with_interval, make_with_interval_and_upper_count

feature {NONE} -- Initialization

	make_with_interval (an_interval: INTEGER)
			-- Create with `an_interval' in milliseconds.
			-- Infinite loop

		require
			an_interval_not_negative: an_interval >= 0
		do
			default_create
			interval := an_interval
			create event_queue.make
			is_bounded_loop := false
			log_name := default_log_name
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

	set_log_name (a_name: like log_name)
			-- Set `name' to `a_name'.
		do
			log_name := a_name
		end

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

	is_visible_in_console: BOOLEAN
			-- is logging output visible in console
		do
			Result := true
		end

feature {NONE} -- Implementation

	on_resumption
			--
		do
			log.enter ("on_resumption")
			event_queue.logged_put (create {EL_REGULAR_INTERVAL_EVENT}.make_delimiter_start)
			elapsed_millisecs := 0
			count := 1
			log.exit
		end

	on_suspension
			--
		do
			log.enter ("on_suspension")
			event_queue.logged_put (create {EL_REGULAR_INTERVAL_EVENT}.make_delimiter_end)
			log.exit
		end

	post_event_after_a_little_sleep
			--
		local
			event: EL_REGULAR_INTERVAL_EVENT
		do
			log.enter ("post_event_after_a_little_sleep")
			sleep (interval)
			if not (is_stopping or is_suspending) then
				elapsed_millisecs := elapsed_millisecs + interval
				create event.make (elapsed_millisecs, count)
				event_queue.logged_put (event)

				count := count + 1

				if is_bounded_loop and count > upper_count then
					stop
				end
			end
			log.exit
		end

	interval: INTEGER

	elapsed_millisecs: INTEGER

	event_queue: EL_THREAD_PRODUCT_QUEUE [EL_REGULAR_INTERVAL_EVENT]

	consumer: EL_REGULAR_INTERVAL_EVENT_CONSUMER

	log_name: STRING

end
