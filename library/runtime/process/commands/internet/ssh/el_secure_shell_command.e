note
	description: "Command that uses a secure shell with ''ssh''"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-25 14:21:38 GMT (Wednesday 25th August 2021)"
	revision: "1"

deferred class
	EL_SECURE_SHELL_COMMAND

feature {NONE} -- Initialization

	make_default
		do
			create user_domain.make_empty
		end

feature -- Access

	user_domain: ZSTRING

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
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := a_path.escaped
			Result.replace_substring_all (s.character_string ('\'), s.n_character_string ('\', 2))
		end

end