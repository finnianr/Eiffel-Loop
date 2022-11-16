note
	description: "Integration distributed over multiple threads"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "5"

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
			distributer := new_distributer (Option.cpu_percent)
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

	add_to_sum
		deferred
		end

	calculate_bound (interval: like split_bounds.item; a_delta_count: INTEGER)
		deferred
		end

	calculate (lower, upper: DOUBLE)
		do
			if is_canceled then
				log.put_line (" integration canceled")
			else
				log.enter ("integral_sum")
				log.put_labeled_string ("Thread priority", Option.priority_name)
				log.put_new_line

				-- Splitting bounds into sub-bounds
				across split_bounds (lower, upper, task_count) as bound loop
					calculate_bound (bound.item, (delta_count / task_count).rounded)
					add_to_sum
				end
				lio.put_line ("Waiting to complete ..")
				distributer.do_final; add_to_sum

				lio.put_integer_field ("distributer.launched_count", distributer.launched_count)
				lio.put_new_line

				if addition_count /= task_count then
					lio.put_line ("ERROR: missing result")
					lio.put_integer_field ("addition_count", addition_count); lio.put_integer_field (" task_count", task_count)
					lio.put_new_line
				end
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

	new_distributer (cpu_percent: INTEGER): EL_WORK_DISTRIBUTER [ANY, ROUTINE]
		deferred
		end

feature {NONE} -- Internal attributes

	addition_count: INTEGER
		-- partial addition count

	delta_count: INTEGER

	distributer: like new_distributer

	task_count: INTEGER

end