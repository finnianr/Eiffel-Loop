note
	description: "Summary description for {EL_LOGGED_WORK_DISTRIBUTION_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_LOGGED_WORK_DISTRIBUTION_THREAD

inherit
	EL_WORK_DISTRIBUTION_THREAD
		undefine
			on_start
		end

	EL_LOGGED_IDENTIFIED_THREAD

create
	make
end
