note
	description: "Command that uses a secure shell with ''ssh''"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 14:01:00 GMT (Tuesday 15th February 2022)"
	revision: "5"

deferred class
	EL_SECURE_SHELL_COMMAND

inherit
	EL_SHARED_OPERATING_ENVIRON

feature -- Access

	user_domain: ZSTRING

	user_name: ZSTRING
		do
			Result := user_domain.substring_to ('@', Default_pointer)
		end

feature -- Element change

	set_user_domain (a_user_domain: ZSTRING)
		do
			user_domain := a_user_domain
		end

feature -- Basic operations

	execute
		require
			user_domain_set: user_domain.count > 0
		deferred
		end

feature {NONE} -- Implementation

	escaped_remote (a_path: EL_PATH): ZSTRING
		-- double escape backslash
		require
			is_absolute: a_path.is_absolute
		local
			s: EL_ZSTRING_ROUTINES; start_index: INTEGER
			local_user, remote_user: ZSTRING
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
				Result.replace_substring_all (s.character_string ('\'), s.n_character_string ('\', 2))
			end
		end

end