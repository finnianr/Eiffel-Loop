note
	description: "[
		Modify or complete a procedures operands as a task distributed across a pool of worker threads.
	]"
	notes: "[
		Define ''modifier'' function with return type [$source PROCEDURE] to complete the operands
		for procedure to be called.
		Apply completed procedures from main thread with **apply** or **apply_final**.
	]"
	descendants: "[
			EL_DISTRIBUTED_PROCEDURE_CALLBACK
				[$source EIFFEL_CLASS_PARSER]
				[$source EIFFEL_CLASS_UPDATE_CHECKER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-06 7:56:29 GMT (Monday 6th June 2022)"
	revision: "2"

class
	EL_DISTRIBUTED_PROCEDURE_CALLBACK

inherit
	EL_FUNCTION_DISTRIBUTER [PROCEDURE]
		rename
			make as make_cpu_percentage
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (cpu_percentage: INTEGER)
		do
			make_cpu_percentage (cpu_percentage)
			create procedure_list.make (20)
		end

feature -- Basic operations

	apply
		-- apply procedures that have been completed
		do
			collect (procedure_list)
			apply_each
		end

	apply_final
		-- wait for thread pool to finish and apply remaining procedures
		do
			do_final; collect_final (procedure_list)
			apply_each
		end

	queue_modifier (modifier: FUNCTION [PROCEDURE])
		do
			wait_apply (modifier)
		end

feature {NONE} -- Implementation

	apply_each
		do
			across procedure_list as list loop
				list.item.apply
			end
			procedure_list.wipe_out
		end

feature {NONE} -- Internal attributes

	procedure_list: ARRAYED_LIST [PROCEDURE]

end