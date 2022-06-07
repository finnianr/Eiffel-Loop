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
	date: "2022-06-07 10:11:07 GMT (Tuesday 7th June 2022)"
	revision: "3"

class
	EL_DISTRIBUTED_PROCEDURE_CALLBACK

inherit
	EL_FUNCTION_DISTRIBUTER [PROCEDURE]
		export
			{NONE} all
		end

create
	make

feature -- Basic operations

	apply
		-- apply procedures that have been completed
		do
			do_with_completed (agent {PROCEDURE}.apply)
		end

	apply_final
		-- wait for thread pool to finish and apply remaining procedures
		do
			do_final; apply
		end

	queue_modifier (modifier: FUNCTION [PROCEDURE])
		do
			wait_apply (modifier)
		end

end