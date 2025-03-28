note
	description: "Mirror directory using Unix **rsync** command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 9:11:58 GMT (Tuesday 9th July 2024)"
	revision: "5"

class
	EL_FILE_RSYNC_COMMAND

inherit
	EL_MIRROR_COMMAND [TUPLE [source_dir, target_dir: STRING]]

create
	make

feature {NONE} -- Constants

	Default_template: STRING = "rsync -av $SOURCE_DIR $TARGET_DIR"
end