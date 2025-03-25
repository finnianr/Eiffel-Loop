note
	description: "[
		OS command executed remotely using the Unix [https://linux.die.net/man/1/ssh ssh command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-25 19:18:02 GMT (Tuesday 25th March 2025)"
	revision: "17"

deferred class
	EL_SECURE_SHELL_OS_COMMAND

inherit
	EL_COMMAND

	EL_SHARED_OPERATING_ENVIRON

	EL_CHARACTER_8_CONSTANTS

feature -- Access

	ssh_context: detachable EL_SECURE_SHELL_CONTEXT

feature -- Status query

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

feature {NONE} -- Implementation

	ssh_escaped (escaped_path: ZSTRING): ZSTRING
		-- double escape backslash
		local
			steps: EL_PATH_STEPS
		do
			steps := escaped_path
		-- replace local user with remote user in destination path
			if steps.index_of (Operating_environ.user_name, 1) = 3 then
				steps [3] := ssh_context.user_name
			end
			Result := steps
			if {PLATFORM}.is_unix then
				Result.replace_substring_all (char ('\') * 1, char ('\') * 2)
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
				["ssh_escaped",				 agent ssh_escaped],
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