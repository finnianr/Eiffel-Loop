note
	description: "Summary description for {EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

deferred class
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	EL_FILE_SYSTEM_OS_COMMAND [T]

feature {NONE} -- Initialization

	make_default
			--
		do
			make_command
		end

	make (a_path: like path)
			--
		do
			make_default
			path := a_path
		end

feature -- Access

	path: PATH_NAME

feature -- Element change

	set_path (a_path: like path)
			--
		do
			path := a_path
		end

end
