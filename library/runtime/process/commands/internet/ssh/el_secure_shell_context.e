note
	description: "[
		OS command executed remotely using the Unix [https://linux.die.net/man/1/ssh ssh command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-25 19:40:27 GMT (Tuesday 25th March 2025)"
	revision: "17"

class
	EL_SECURE_SHELL_CONTEXT

inherit
	EVC_REFLECTIVE_EIFFEL_CONTEXT
		rename
			escaped_field as unescaped_field
		redefine
			make_default
		end

	EL_REFLECTIVE
		rename
			foreign_naming as eiffel_naming,
			field_included as is_string_or_expanded_field
		end

	EL_MODULE_DIRECTORY

	EL_STRING_GENERAL_ROUTINES

	EL_CHARACTER_8_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create user_domain.make_empty
			ssh_option := Empty_string_8
		end

feature {NONE} -- Initialization

	make (a_user_domain: READABLE_STRING_GENERAL)
		do
			make_default
			set_user_domain (a_user_domain)
		end

feature -- Access

	domain_name: ZSTRING
		do
			Result := user_domain.substring_to_reversed ('@')
		end

	user_domain: ZSTRING
		-- user and domain name, eg. joe@joe-blogs.com

	user_name: ZSTRING
		do
			Result := user_domain.substring_to ('@')
		end

feature -- Status query

	is_default: BOOLEAN
		do
			Result := user_domain.is_empty
		end

	is_open: BOOLEAN
		do
			Result := SSH_command.count > 0
		end

feature -- Status change

	close
		local
			ssh_close: EL_OS_COMMAND
		do
			ssh_option := new_socket_option
			create ssh_close.make_with_name ("ssh_close", "ssh -O exit $ssh_option $user_domain")
			ssh_close.put_fields (Current)
			ssh_close.execute
			ssh_option := Empty_string_8
		end

	open
		local
			ssh_open: EL_OS_COMMAND
		do
			ssh_option := new_socket_option
			create ssh_open.make_with_name ("ssh_open", "ssh -M $ssh_option -N -f $user_domain")
			ssh_open.put_fields (Current)
			ssh_open.execute
		end

feature -- Element change

	set_user_domain (a_user_domain: READABLE_STRING_GENERAL)
		do
			user_domain.wipe_out
			user_domain.append_string_general (a_user_domain)
		end

feature {NONE} -- Implementation

	new_socket_option: STRING
		do
			Result := Socket_option_template #$ [Directory.home, domain_name]
		end

feature {NONE} -- Evolicity reflection

	get_socket_command: STRING
		do
			Result := space.joined (SSH_command, ssh_option)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["command",		 agent get_socket_command],
				["user_domain", agent: ZSTRING do Result := user_domain end]
			>>)
		end

feature {NONE} -- Internal attributes

	ssh_option: STRING

feature {NONE} -- Constants

	SSH_command: STRING = "ssh"

	Socket_option_template: ZSTRING
		once
			Result := "-S %S/.ssh/%S.socket"
		end
end