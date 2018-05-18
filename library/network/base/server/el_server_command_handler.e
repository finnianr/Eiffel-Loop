note
	description: "Summary description for {EL_SERVER_COMMAND_HANDLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-10 19:03:04 GMT (Thursday 10th May 2018)"
	revision: "4"

deferred class
	EL_SERVER_COMMAND_HANDLER

feature {NONE} -- Initialization

	make
		do
			response := Response_ok
			create arguments.make_empty
			command_table := new_command_table
		end

feature -- Access

	response: STRING

feature -- Basic operations

	execute (command, a_arguments: STRING)
		do
			arguments := a_arguments
			if command_table.has_key (command) then
				command_table.found_item.apply
			end
		end

feature {NONE} -- Implementation

	command_table: EL_HASH_TABLE [PROCEDURE, STRING]

	new_command_table: like command_table
		deferred
		end

	arguments: STRING

feature {EL_SIMPLE_SERVER} -- Constants

	Response_ok: STRING = "ok"

end
