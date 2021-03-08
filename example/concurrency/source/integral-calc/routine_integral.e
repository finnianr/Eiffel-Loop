note
	description: "Routine integral"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 13:29:37 GMT (Wednesday 8th January 2020)"
	revision: "4"

deferred class
	ROUTINE_INTEGRAL [G]

inherit
	EL_DOUBLE_MATH

	EL_MODULE_LOG

	EL_MODULE_EXCEPTION

feature {NONE} -- Initialization

	make (a_delta_count, a_task_count, thread_count: INTEGER; is_max_priority: BOOLEAN)
		do
			delta_count := a_delta_count; task_count := a_task_count
			create result_list.make (task_count)
			create distributer.make (thread_count)
			if is_max_priority then
				distributer.set_max_priority
			end
		end

feature -- Basic operations

	integral_sum (f: FUNCTION [DOUBLE, DOUBLE]; lower, upper: DOUBLE): DOUBLE
		do
			if is_canceled then
				log.put_line (" integration canceled")
			else
				log.enter ("integral_sum")

				-- Splitting bounds into sub-bounds
				across split_bounds (lower, upper, task_count) as bound loop
					collect_integral (f, bound.item.lower_bound, bound.item.upper_bound, (delta_count / task_count).rounded)
				end
				lio.put_line ("Waiting to complete ..")
				distributer.do_final
				collect_final

				lio.put_integer_field ("distributer.launched_count", distributer.launched_count)
				lio.put_new_line

				if not result_list.full then
					lio.put_line ("ERROR: missing result")
					lio.put_integer_field ("result_list.count", result_list.count); lio.put_integer_field (" task_count", task_count)
					lio.put_new_line
				end
				Result := result_sum
				result_list.wipe_out
			end
			log.exit
		rescue
			if Exception.last.is_signal then
				distributer.do_final
				is_canceled := True
				Exception.last.no_message_on_failure
				retry
			end
		end

feature -- Status query

	is_canceled: BOOLEAN

feature {NONE} -- Implementation

	collect_final
		deferred
		end

	collect_integral (function: FUNCTION [DOUBLE, DOUBLE]; lower, upper: DOUBLE; a_delta_count: INTEGER)
		deferred
		end

	result_sum: DOUBLE
		-- sum of results of all sub-bounds
		deferred
		end

feature {NONE} -- Internal attributes

	delta_count: INTEGER

	distributer: EL_WORK_DISTRIBUTER [ROUTINE]

	result_list: ARRAYED_LIST [G]

	task_count: INTEGER

end
