note
	description: "[
		OS command executed remotely using the Unix [https://linux.die.net/man/1/ssh ssh command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:50:49 GMT (Sunday 30th March 2025)"
	revision: "20"

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

	EL_STRING_GENERAL_ROUTINES_I

	EL_CHARACTER_8_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create user_domain.make_empty
			create ssh_command_list.make (2)
			ssh_command_list.extend ("ssh")
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
			Result := ssh_option.count > 0
		end

feature -- Status change

	close
		do
			if is_open then
				new_ssh_command ("ssh_close", "ssh -O exit $ssh_option $user_domain").execute
				ssh_command_list.remove_tail (1)
				ssh_option := Empty_string_8
			end
		ensure
			ssh_option_empty: ssh_option.count = 0
			only_ssh: ssh_command_list.count = 1
		end

	open
		do
			ssh_option := new_socket_option
			ssh_command_list.extend (ssh_option)
			new_ssh_command ("ssh_open", "ssh -M $ssh_option -N -f $user_domain").execute
		ensure
			ssh_over_socket: ssh_command_list.count = 2
		end

feature -- Element change

	set_user_domain (a_user_domain: READABLE_STRING_GENERAL)
		do
			user_domain.wipe_out
			user_domain.append_string_general (a_user_domain)
		end

feature {NONE} -- Implementation

	new_ssh_command (name, a_template: STRING): EL_OS_COMMAND
		do
			create Result.make_with_name (name, a_template)
			Result.put_fields (Current)
		ensure
			variables_set: Result.all_variables_set
		end

	new_socket_option: STRING
		do
			Result := Socket_option_template #$ [Directory.home, domain_name]
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["command",		 agent: STRING do Result := ssh_command_list.as_word_string end],
				["user_domain", agent: ZSTRING do Result := user_domain end]
			>>)
		end

feature {NONE} -- Internal attributes

	ssh_command_list: EL_STRING_8_LIST

	ssh_option: STRING

feature {NONE} -- Constants

	Socket_option_template: ZSTRING
		once
			Result := "-S %S/.ssh/%S.socket"
		end
end