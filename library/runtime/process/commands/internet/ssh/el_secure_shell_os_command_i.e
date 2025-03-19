note
	description: "[
		OS command executed remotely using the Unix [https://linux.die.net/man/1/ssh ssh command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:53 GMT (Tuesday 18th March 2025)"
	revision: "16"

deferred class
	EL_SECURE_SHELL_OS_COMMAND_I

inherit
	EL_COMMAND

	EL_SHARED_OPERATING_ENVIRON

	EL_CHARACTER_32_CONSTANTS

	EL_STRING_GENERAL_ROUTINES

feature {NONE} -- Initialization

	make_default
		do
		end

feature -- Access

	ssh_context: EL_SECURE_SHELL_CONTEXT

feature -- Element change

	set_ssh_context (a_ssh_context: EL_SECURE_SHELL_CONTEXT)
		do
			ssh_context := a_ssh_context
		end
	
feature {NONE} -- Deferred

	getter_functions: EVC_FUNCTION_TABLE
		deferred
		end

end