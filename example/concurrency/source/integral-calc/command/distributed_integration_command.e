note
	description: "Integration distributed over multiple threads"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 14:57:02 GMT (Sunday 20th February 2022)"
	revision: "3"

deferred class
	DISTRIBUTED_INTEGRATION_COMMAND [G]

inherit
	INTEGRATION_COMMAND
		redefine
			make, is_canceled
		end

	EL_MODULE_EXCEPTION

feature {NONE} -- Initialization

	make (a_option: like option; a_function: like function)
		do
			Precursor (a_option, a_function)
			delta_count := option.delta_count; task_count := option.task_count
			create result_list.make (task_count)
			create distributer.make (Option.cpu_percent)
			if option.max_priority then
				distributer.set_max_priority
			end
		end

feature -- Access

	description: STRING
		local
			type: TYPE [like distributer]
		do
			type := {like distributer}
			Result :=  "Distributed integration using type " + type.out
		end

feature -- Status query

	is_canceled: BOOLEAN

feature {NONE} -- Implementation

	collect_final
		deferred
		end

	collect_integral (lower, upper: DOUBLE; a_delta_count: INTEGER)
		deferred
		end

	integral_sum (lower, upper: DOUBLE): DOUBLE
		do
			if is_canceled then
				log.put_line (" integration canceled")
			else
				log.enter ("integral_sum")
				log.put_labeled_string ("Thread priority", Option.priority_name)
				log.put_new_line

				-- Splitting bounds into sub-bounds
				across split_bounds (lower, upper, task_count) as bound loop
					collect_integral (bound.item.lower_bound, bound.item.upper_bound, (delta_count / task_count).rounded)
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