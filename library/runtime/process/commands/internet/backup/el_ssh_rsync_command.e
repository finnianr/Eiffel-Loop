note
	description: "[
		Mirror local to remote directory using Unix **rsync** command over a secure shell connection
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-25 17:42:15 GMT (Friday 25th August 2023)"
	revision: "6"

class
	EL_SSH_RSYNC_COMMAND

inherit
	EL_MIRROR_COMMAND [TUPLE [source_dir, user, host, target_dir: STRING]]
		redefine
			make, set_target_dir, source_dir_index
		end

	EL_CHARACTER_32_CONSTANTS

create
	 make

feature {NONE} -- Initialization

	make (config: EL_REMOTE_MIRROR_BACKUP)
		do
			Precursor (config)
			put_string (Var.host, config.host)
			put_string (Var.user, config.user)
		end

feature -- Element change

	set_target_dir (target_dir: DIR_PATH)
		local
			escaped_path: ZSTRING
		do
			escaped_path := target_dir.escaped
			-- Double escape for target
			if {PLATFORM}.is_unix and then escaped_path.has ('\') then
				escaped_path.replace_substring_all (char ('\') * 1, char ('\') * 2)
			end
			put_string (var.target_dir, escaped_path)
		end

feature {NONE} -- Implementation

	source_dir_index: INTEGER
		do
			Result := 1
		end

feature {NONE} -- Constants

	Template: STRING = "rsync -avz -e ssh $SOURCE_DIR $USER@$HOST:$TARGET_DIR"

end