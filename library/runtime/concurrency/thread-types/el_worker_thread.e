note
	description: "Summary description for {EL_WORKER_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-23 10:22:21 GMT (Thursday 23rd April 2015)"
	revision: "3"

class
	EL_WORKER_THREAD

inherit
	EL_IDENTIFIED_THREAD
		redefine
			log_name
		end

create
	make

feature {NONE} -- Initialization

	make (a_work_action: like work_action)
		do
			make_default
			work_action := a_work_action
		end

feature -- Access

	log_name: STRING
			--
		do
			Result := work_action.target.generator.as_lower
		end

feature {NONE} -- Implementation

	work_action: PROCEDURE [ANY, TUPLE]

	execute
		do
			work_action.apply
		end

end
