note
	description: "Mirror directory using Unix **rsync** command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-25 17:39:36 GMT (Friday 25th August 2023)"
	revision: "4"

class
	EL_FILE_RSYNC_COMMAND

inherit
	EL_MIRROR_COMMAND [TUPLE [source_dir, target_dir: STRING]]

create
	make

feature {NONE} -- Constants

	Template: STRING = "rsync -av $SOURCE_DIR $TARGET_DIR"
end