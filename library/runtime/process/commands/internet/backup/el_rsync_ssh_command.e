note
	description: "Mirror to remote directory using Unix **rsync** command over a secure shell connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 16:27:26 GMT (Thursday 17th August 2023)"
	revision: "5"

class
	EL_RSYNC_SSH_COMMAND

inherit
	EL_MIRROR_COMMAND [TUPLE [source_dir, user, host, target_dir: STRING]]
		redefine
			set_target_dir
		end

	EL_CHARACTER_32_CONSTANTS

create
	 make

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

	var_index: TUPLE [host, user, passphrase, source_dir, target_dir: INTEGER]
		do
			Result := [3, 2, 0, 1, 4]
		end

feature {NONE} -- Constants

	Template: STRING = "rsync -avz -e ssh $SOURCE_DIR $USER@$HOST:$TARGET_DIR"

end