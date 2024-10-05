note
	description: "[
		OS command executed remotely using the Unix [https://linux.die.net/man/1/ssh ssh command]
	]"
	descendants: "[
			EL_SECURE_SHELL_COMMAND*
				${EL_RSYNC_COMMAND_I*}
					${EL_RSYNC_COMMAND_IMP}
				${EL_SSH_DIRECTORY_COMMAND*}
					${EL_SSH_TEST_DIRECTORY_COMMAND}
					${EL_SSH_MAKE_DIRECTORY_COMMAND}
				${EL_SSH_MD5_HASH_COMMAND}
				${EL_SSH_COPY_COMMAND}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2008-04-21 19:24:48 GMT (Monday 21st April 2008)"
	revision: "14"

deferred class
	EL_SECURE_SHELL_COMMAND

inherit
	EL_COMMAND

	EL_SHARED_OPERATING_ENVIRON

	EL_CHARACTER_32_CONSTANTS

	EL_STRING_GENERAL_ROUTINES

feature {NONE} -- Initialization

	make (a_user_domain: READABLE_STRING_GENERAL)
		do
			make_with_template
			set_user_domain (a_user_domain)
		end

feature -- Access

	user_domain: ZSTRING

	user_name: ZSTRING
		do
			Result := user_domain.substring_to ('@')
		end

feature -- Element change

	set_user_domain (a_user_domain: READABLE_STRING_GENERAL)
		do
			user_domain := as_zstring (a_user_domain)
			put_string (var_user_domain, user_domain)
		end

feature {NONE} -- Implementation

	escaped_remote (a_path: EL_PATH): ZSTRING
		-- double escape backslash
		require
			is_absolute: a_path.is_absolute
		local
			start_index: INTEGER; local_user, remote_user: ZSTRING
		do
			Result := a_path.escaped
			local_user := Operating_environ.user_name; remote_user := user_name
			if remote_user /~ local_user then
				-- replace local user with remote user
				start_index := Result.substring_index (local_user, 1)
				if start_index >= 2 and then Result [start_index - 1] = Operating_environ.Directory_separator then
					Result.replace_substring (remote_user, start_index, start_index + local_user.count - 1)
				end
			end
			if {PLATFORM}.is_unix and then Result.has ('\') then
				Result.replace_substring_all (char ('\') * 1, char ('\') * 2)
			end
		end

	put_remote_path (variable_name: READABLE_STRING_8; a_path: EL_PATH)
		-- put path with double escaped backslash
		do
			put_string (variable_name, escaped_remote (a_path))
		end

feature {NONE} -- Deferred

	make_with_template
		deferred
		end

	put_string (variable_name: READABLE_STRING_8; value: READABLE_STRING_GENERAL)
		deferred
		end

	var_user_domain: STRING
		deferred
		end

end