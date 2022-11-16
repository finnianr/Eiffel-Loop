note
	description: "Simple command handler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	SIMPLE_COMMAND_HANDLER

inherit
	EL_SERVER_COMMAND_HANDLER

	EL_MODULE_LOG

create
	make

feature {NONE} -- Implementation

	greeting (arg: STRING)
		do
			log.put_string_field ("greeting", arg)
			log.put_new_line
			socket.put_string_8 ("hello")
			socket.put_new_line
		end

	number (arg: STRING)
		do
			log.put_labeled_string ("number", arg)
			log.put_new_line
			socket.put_string_8 (Response_ok)
			socket.put_new_line
		end

	new_command_table: like command_table
		do
			create Result.make (<<
				["greeting", agent greeting],
				["number", agent number]
			>>)
		end

end