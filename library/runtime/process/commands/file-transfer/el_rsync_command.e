note
	description: "Mirror directory using Unix **rsync** command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 9:53:37 GMT (Sunday 20th February 2022)"
	revision: "1"

class
	EL_RSYNC_COMMAND

inherit
	EL_MIRROR_COMMAND [TUPLE [source_dir, target_dir: STRING]]

create
	make

feature {NONE} -- Implementation

	var_index: TUPLE [host, user, passphrase, source_dir, target_dir: INTEGER]
		do
			Result := [0, 0, 0, 1, 2]
		end

feature {NONE} -- Constants

	Template: STRING = "rsync -av $SOURCE_DIR $TARGET_DIR"
end