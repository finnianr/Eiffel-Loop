note
	description: "Command that uses a secure shell with ''ssh''"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 10:29:56 GMT (Sunday 20th February 2022)"
	revision: "6"

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

	destination_dir: DIR_PATH

feature -- Element change

	set_destination_dir (a_destination_dir: DIR_PATH)
		do
			destination_dir := a_destination_dir
			put_string_variable (var_index.destination_dir, escaped_remote (a_destination_dir))
		end

	set_user_domain (a_user_domain: ZSTRING)
		do
			user_domain := a_user_domain
			put_string_variable (var_index.user_domain, a_user_domain)
		end

	set_source_path (source_path: EL_PATH)
		do
			put_path_variable (var_index.source_path, source_path)
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

feature {NONE} -- Deferred

	put_path_variable (index: INTEGER; a_path: EL_PATH)
		deferred
		end

	put_string_variable (index: INTEGER; value: READABLE_STRING_GENERAL)
		deferred
		end

	var_index: TUPLE [source_path, user_domain, destination_dir: INTEGER]
		deferred
		end

end