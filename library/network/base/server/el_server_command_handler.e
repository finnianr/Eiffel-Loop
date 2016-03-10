note
	description: "Summary description for {EL_SERVER_COMMAND_HANDLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

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
			command_table.search (command)
			if command_table.found then
				command_table.found_item.apply
			end
		end

feature {NONE} -- Implementation

	command_table: EL_HASH_TABLE [PROCEDURE [like Current, TUPLE], STRING]

	new_command_table: like command_table
		deferred
		end

	arguments: STRING

feature {EL_SIMPLE_SERVER} -- Constants

	Response_ok: STRING = "ok"

end
