note
	description: "[
		Modify or complete a procedures operands as a task distributed across a pool of worker threads.
	]"
	notes: "[
		Apply completed procedures from main thread with **apply** or **apply_final**.
	]"
	descendants: "[
			EL_DISTRIBUTED_PROCEDURE_CALLBACK
				${EIFFEL_CLASS_PARSER}
				${EIFFEL_CLASS_UPDATE_CHECKER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-02 10:20:06 GMT (Tuesday 2nd April 2024)"
	revision: "7"

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