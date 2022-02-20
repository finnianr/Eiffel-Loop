note
	description: "Mirror to remote directory using Unix **rsync** command over a secure shell connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 9:53:48 GMT (Sunday 20th February 2022)"
	revision: "2"

class
	EL_RSYNC_SSH_COMMAND

inherit
	EL_MIRROR_COMMAND [TUPLE [source_dir, user, host, target_dir: STRING]]
		redefine
			set_target_dir
		end

create
	 make

feature -- Element change

	set_target_dir (target_dir: DIR_PATH)
		local
			escaped_path: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			escaped_path := target_dir.escaped
			-- Double escape for target
			if {PLATFORM}.is_unix and then escaped_path.has ('\') then
				escaped_path.replace_substring_all (s.character_string ('\'), s.n_character_string ('\', 2))
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