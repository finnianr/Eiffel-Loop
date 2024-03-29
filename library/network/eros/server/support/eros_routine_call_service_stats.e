note
	description: "Routine call service stats"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EROS_ROUTINE_CALL_SERVICE_STATS

inherit
	EROS_ROUTINE_CALL_SERVICE_EVENT_LISTENER
		redefine
			called_routine, received_bytes, sent_bytes, routine_failed, add_connection, remove_connection
		end

	EL_MODULE_LOG
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_max_threads: INTEGER)
			--
		do
			max_threads := a_max_threads

			create thread_count.make
			create queued_connection_count.make

			create function_count.make
			create function_rate_calculator

			create procedure_count.make
			create procedure_rate_calculator

			create failure_count.make
			create bytes_received_count.make
			create bytes_received_rate_calculator

			create bytes_sent_count.make
			create bytes_sent_rate_calculator
		end

feature -- Element change

	set_display_refresh_timer (refresh_timer: EL_REGULAR_INTERVAL_EVENT_PROCESSOR)
			--
		do
			display_refresh_timer := refresh_timer
		end

feature -- Access

	procedure_rate: INTEGER
			-- procedures executed per second
		do
			procedure_rate_calculator.update (procedure_count.item)
			Result := procedure_rate_calculator.item.rounded
		end

	function_rate: INTEGER
			-- functions executed per second
		do
			function_rate_calculator.update (function_count.item)
			Result := function_rate_calculator.item.rounded
		end

	bytes_received_rate: DOUBLE
			--
		do
			bytes_received_rate_calculator.update (bytes_received_count.item)
			Result := bytes_received_rate_calculator.item
		end

	bytes_sent_rate: DOUBLE
			--
		do
			bytes_sent_rate_calculator.update (bytes_sent_count.item)
			Result := bytes_sent_rate_calculator.item
		end

	max_threads: INTEGER

	thread_count: EL_MUTEX_NUMERIC [INTEGER]

	queued_connection_count: EL_MUTEX_NUMERIC [INTEGER]

	procedure_count: EL_MUTEX_NUMERIC [INTEGER]

	function_count: EL_MUTEX_NUMERIC [INTEGER]

	bytes_received_count: EL_MUTEX_NUMERIC [INTEGER_64]

	bytes_sent_count: EL_MUTEX_NUMERIC [INTEGER_64]

	failure_count: EL_MUTEX_NUMERIC [INTEGER]

feature -- Basic operations

	reset
			--
		do
			function_rate_calculator.reset
			procedure_rate_calculator.reset
			bytes_received_rate_calculator.reset
			bytes_sent_rate_calculator.reset

			thread_count.set_item (0)
			queued_connection_count.set_item (0)
			function_count.set_item (0)
			procedure_count.set_item (0)
			failure_count.set_item (0)
			bytes_received_count.set_item (0)
			bytes_sent_count.set_item (0)
		end

feature {NONE} -- Routine call activity events

	called_routine (is_function: BOOLEAN)
			--
		do
			if is_function then
				function_count.increment
			else
				procedure_count.increment
			end
		end

	routine_failed
			--
		do
			failure_count.increment
		end

	received_bytes (bytes: INTEGER_64)
			--
		do
			bytes_received_count.add (bytes)
		end

	sent_bytes (bytes: INTEGER_64)
			--
		do
			bytes_sent_count.add (bytes)
		end

	add_connection
			--
		do
			if thread_count.item < max_threads then
				thread_count.increment
			else
				queued_connection_count.increment
			end
			if thread_count.item = 1 then
				display_refresh_timer.start
			end
		end

	remove_connection
			--
		do
			if queued_connection_count.item > 0 then
				queued_connection_count.decrement
			else
				thread_count.decrement
			end
			if thread_count.item = 0 then
				display_refresh_timer.stop
			end
		end

feature {NONE} -- Implementation

	display_refresh_timer: EL_REGULAR_INTERVAL_EVENT_PROCESSOR

	function_rate_calculator: EL_QUANTITY_INCREASE_RATE_CALCULATOR

	procedure_rate_calculator: EL_QUANTITY_INCREASE_RATE_CALCULATOR

	bytes_received_rate_calculator: EL_QUANTITY_INCREASE_RATE_CALCULATOR

	bytes_sent_rate_calculator: EL_QUANTITY_INCREASE_RATE_CALCULATOR

end