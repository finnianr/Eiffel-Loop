note
	description: "Mirror to remote directory using Unix **rsync** command over a secure shell connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 16:48:48 GMT (Saturday 19th February 2022)"
	revision: "1"

class
	EL_RSYNC_SSH_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [source_dir, user, host, target_dir: STRING]]

create
	 make

feature -- Element change

	set_host (name: STRING)
		do
			put_string (var.host, name)
		end

	set_source_dir (source_dir: DIR_PATH)
		do
			put_string (var.source_dir, source_dir)
		end

	set_target_dir (target_dir: DIR_PATH)
		do
			put_path (var.target_dir, target_dir)
		end

	set_user (user: ZSTRING)
		do
			put_string (var.user, user)
		end

feature {NONE} -- Constants

	Template: STRING = "rsync -avz -e ssh $SOURCE_DIR $USER@$HOST:$TARGET_DIR"

end