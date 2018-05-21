note
	description: "Worker thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

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