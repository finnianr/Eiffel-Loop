note
	description: "OS command that mirrors a directory either locally or remotely"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_MIRROR_COMMAND [VARIABLES -> TUPLE create default_create end]

inherit
	EL_PARSED_OS_COMMAND [VARIABLES]

feature -- Element change

	set_host (name: STRING)
		do
			put_string_variable (var_index.host, name)
		end

	set_passphrase (passphrase: ZSTRING)
		do
			put_string_variable (var_index.passphrase, passphrase)
		end

	set_source_dir (source_dir: DIR_PATH)
		do
			put_path_variable (var_index.source_dir, source_dir)
		end

	set_target_dir (target_dir: DIR_PATH)
		do
			put_path_variable (var_index.target_dir, target_dir)
		end

	set_user (user: ZSTRING)
		do
			put_string_variable (var_index.user, user)
		end

feature {NONE} -- Deferred

	var_index: TUPLE [host, user, passphrase, source_dir, target_dir: INTEGER]
		deferred
		end

end