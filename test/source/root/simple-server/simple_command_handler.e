note
	description: "Simple command handler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

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