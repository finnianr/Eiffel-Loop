note
	description: "[
		Modify or complete a procedures operands as a task distributed across a pool of worker threads.
	]"
	notes: "[
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
	date: "2022-06-11 9:50:38 GMT (Saturday 11th June 2022)"
	revision: "4"

class
	EL_DISTRIBUTED_PROCEDURE_CALLBACK

inherit
	EL_FUNCTION_DISTRIBUTER [PROCEDURE]
		export
			{NONE} all
			{ANY} wait_apply
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

end