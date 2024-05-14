note
	description: "[
		${EL_MIRROR_BACKUP} for **ssh** protocol using ${EL_SSH_RSYNC_COMMAND} command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-14 11:19:53 GMT (Tuesday 14th May 2024)"
	revision: "3"

class
	EL_SSH_MIRROR_BACKUP

inherit
	EL_REMOTE_MIRROR_BACKUP
		rename
			element_node_fields as Empty_set
		end

create
	make

feature -- Access

	host: STRING

	user: ZSTRING

feature {NONE} -- Implementation

	new_command (backup_target_dir: DIR_PATH): EL_SSH_RSYNC_COMMAND
		do
			create Result.make (Current)
		end

end