note
	description: "Worker thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-24 12:43:59 GMT (Tuesday 24th December 2019)"
	revision: "6"

class
	EL_WORKER_THREAD

inherit
	EL_IDENTIFIED_THREAD

create
	make

feature {NONE} -- Initialization

	make (a_work_action: PROCEDURE)
		do
			make_default
			work_action := a_work_action
			set_name (new_name (a_work_action.target.generator))
		end

feature {NONE} -- Implementation

	work_action: PROCEDURE

	execute
		do
			work_action.apply
		end

end
