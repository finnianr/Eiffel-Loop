note
	description: "Summary description for {EL_WORKER_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_WORKER_THREAD

inherit
	EL_IDENTIFIED_THREAD

create
	make

feature {NONE} -- Initialization

	make (a_work_action: like work_action)
		do
			make_default
			work_action := a_work_action
			set_name (new_name (a_work_action.target.generator))
		end

feature {NONE} -- Implementation

	work_action: PROCEDURE [ANY, TUPLE]

	execute
		do
			work_action.apply
		end

end