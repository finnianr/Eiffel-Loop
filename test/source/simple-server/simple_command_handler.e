note
	description: "Summary description for {SIMPLE_CLIENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_COMMAND_HANDLER

inherit
	EL_SERVER_COMMAND_HANDLER

	EL_MODULE_LOG

create
	make

feature {NONE} -- Implementation

	greeting
		do
			log.put_line (arguments)
		end

	one
		do
			log.put_line (arguments)
		end

	two
		do
			log.put_line (arguments)
		end

	new_command_table: like command_table
		do
			create Result.make (<<
				["greeting", agent greeting],
				["one", agent one],
				["two", agent two]
			>>)
		end

end
