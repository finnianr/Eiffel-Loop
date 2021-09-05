note
	description: "Remote file synchronization using rsync over ssh"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 16:33:13 GMT (Wednesday 1st September 2021)"
	revision: "2"

deferred class
	EL_FILE_SYNC_COMMAND_I

inherit
	EL_COPY_TREE_COMMAND_I
		redefine
			getter_function_table, make_default
		end

	EL_SECURE_SHELL_COMMAND
		redefine
			make_default, escaped_remote
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			create exclude_list.make (0)
			create progress
			Precursor {EL_SECURE_SHELL_COMMAND}
			Precursor {EL_COPY_TREE_COMMAND_I}
		end

feature -- Access

	exclude_list: EL_ZSTRING_LIST

feature -- Status query

	progress: EL_BOOLEAN_OPTION

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["destination_path",	agent: ZSTRING do Result := escaped_remote (destination_path) end] +
				["exclude_list",		agent: ITERABLE [ZSTRING] do Result := exclude_list end] +
				["user_domain",		agent: ZSTRING do Result := user_domain end]
		end

feature {NONE} -- Implementation

	escaped_remote (a_path: EL_PATH): ZSTRING
		-- double escape backslash
		do
			if user_domain.count > 0 then
				Result := Precursor (a_path)
			else
				Result := a_path.escaped
			end
		end
end