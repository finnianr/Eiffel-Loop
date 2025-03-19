note
	description: "[
		OS command executed remotely using the Unix [https://linux.die.net/man/1/ssh ssh command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:00:34 GMT (Tuesday 18th March 2025)"
	revision: "16"

class
	EL_SECURE_SHELL_CONTEXT

inherit
	EVC_EIFFEL_CONTEXT
		redefine
			make_default
		end

	EL_SHARED_OPERATING_ENVIRON

	EL_CHARACTER_32_CONSTANTS

	EL_STRING_GENERAL_ROUTINES

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create user_domain.make_empty
		end

feature {NONE} -- Initialization

	make (a_user_domain: READABLE_STRING_GENERAL)
		do
			set_user_domain (a_user_domain)
		end

feature -- Access

	user_domain: ZSTRING

	user_name: ZSTRING
		do
			Result := user_domain.substring_to ('@')
		end

feature -- Status query

	is_default: BOOLEAN
		do
			Result := user_domain.is_empty
		end

feature -- Element change

	set_user_domain (a_user_domain: READABLE_STRING_GENERAL)
		do
			user_domain.wipe_out
			user_domain.append_string_general (a_user_domain)
		end

feature {NONE} -- Implementation

	escaped_remote (escaped_path: ZSTRING): ZSTRING
		-- double escape backslash
		local
			steps: EL_PATH_STEPS
		do
			steps := escaped_path
		-- replace local user with remote user in destination path
			if steps.index_of (Operating_environ.user_name, 1) = 3 then
				steps [3] := user_name
			end
			Result := steps
			if {PLATFORM}.is_unix then
				Result.replace_substring_all (char ('\') * 1, char ('\') * 2)
			end
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["escaped",		 agent escaped_remote],
				["is_default",	 agent: BOOLEAN_REF do Result := is_default.to_reference end],
				["user_domain", agent: ZSTRING do Result := user_domain end]
			>>)
		end

end