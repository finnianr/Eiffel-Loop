note
	description: "Worker thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-20 8:06:13 GMT (Thursday 20th May 2021)"
	revision: "7"

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
			set_name (new_english_name (a_work_action.target.generator))
		end

feature {NONE} -- Implementation

	work_action: PROCEDURE

	execute
		do
			work_action.apply
		end

end