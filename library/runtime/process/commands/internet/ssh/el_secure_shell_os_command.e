note
	description: "[
		OS command executed remotely using the Unix [https://linux.die.net/man/1/ssh ssh command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-27 14:43:35 GMT (Thursday 27th March 2025)"
	revision: "19"

deferred class
	EL_SECURE_SHELL_OS_COMMAND

inherit
	EL_COMMAND

	EL_SHARED_OPERATING_ENVIRON

	EL_CHARACTER_8_CONSTANTS

feature -- Access

	ssh_context: detachable EL_SECURE_SHELL_CONTEXT note option: transient attribute end
		-- optional SSH context
		-- (transient attribute prevents default creation by EL_OS_COMMAND_I)

feature -- Status query

	has_error: BOOLEAN
		-- True if the command returned an error code on exit
		deferred
		end

	is_remote_destination: BOOLEAN
		do
			Result := ssh_context /= Void
		end

feature -- Element change

	set_ssh_context (a_ssh_context: EL_SECURE_SHELL_CONTEXT)
		do
			ssh_context := a_ssh_context
		ensure
			valid_template: template_has (Var_is_remote_destination)
		end

feature -- Basic operations

	print_error (a_description: detachable READABLE_STRING_GENERAL)
		deferred
		end

feature {NONE} -- Implementation

	remote (escaped_path: ZSTRING): ZSTRING
		--replace local user with remote user in destination path
		local
			step_list: EL_ZSTRING_LIST
		do
			if ssh_context.user_name ~ Operating_environ.user_name then
				Result := escaped_path.twin
			else
				create step_list.make_adjusted_split (escaped_path, '/', 0)
				if step_list.index_of (Operating_environ.user_name, 1) = 3 then
					step_list [3] := ssh_context.user_name
				end
				Result := step_list.joined ('/')
			end
		-- turn escaped string into a quoted string which removes the need for escaping
			if Result.has ('\') then
				Result.prune_all ('\')
				Result.quote (1) -- single quote
			end
		end

feature {NONE} -- Evolicity reflection

	get_is_remote_destination: BOOLEAN_REF
		do
			Result := is_remote_destination.to_reference
		end

	get_ssh_context: EL_SECURE_SHELL_CONTEXT
		do
			if attached ssh_context as context then
				Result := context
			else
				create Result.make_default
			end
		end

	getter_function_table: EVC_FUNCTION_TABLE
		do
			create Result.make_assignments (<<
				["remote", agent remote],
				[Var_is_remote_destination, agent get_is_remote_destination],
				[Var_ssh,						 agent get_ssh_context]
			>>)
		end

feature {NONE} -- Deferred

	template_has (name: READABLE_STRING_8): BOOLEAN
		deferred
		end

feature {NONE} -- Constants

	Var_is_remote_destination: STRING = "is_remote_destination"

	Var_ssh: STRING = "ssh"

end