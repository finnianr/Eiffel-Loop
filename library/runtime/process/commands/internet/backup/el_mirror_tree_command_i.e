note
	description: "[
		A ${EL_COPY_TREE_COMMAND_I} abstraction that can be configured by a class conforming to
		${EL_MIRROR_BACKUP}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 14:08:03 GMT (Friday 28th March 2025)"
	revision: "1"

deferred class
	EL_MIRROR_TREE_COMMAND_I

inherit
	EL_COPY_TREE_COMMAND_I

feature {NONE} -- Initialization

	make_backup (config: EL_MIRROR_BACKUP)
		do
			make_default
			destination_path := config.backup_dir
		end

end