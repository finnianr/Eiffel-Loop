indexing
	description: "Summary description for {EL_FILE_SYSTEM_OS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_FILE_SYSTEM_OS_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	EL_OS_COMMAND [T]
		rename
			make as make_command
		end
		
end

