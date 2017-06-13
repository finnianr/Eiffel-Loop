note
	description: "Summary description for {EL_LOGGED_PROCEDURE_DISTRIBUTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_LOGGED_PROCEDURE_DISTRIBUTER [G]

inherit
	EL_PROCEDURE_DISTRIBUTER [G]
		redefine
			new_thread
		end

create
	make

feature {NONE} -- Implementation

	new_thread: EL_LOGGED_WORK_DISTRIBUTION_THREAD
		do
			create Result.make (Current)
		end

end
