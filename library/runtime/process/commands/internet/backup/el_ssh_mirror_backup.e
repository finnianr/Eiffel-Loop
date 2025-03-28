note
	description: "[
		${EL_MIRROR_BACKUP} for **ssh** protocol using ${EL_SSH_RSYNC_COMMAND} command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 15:39:26 GMT (Friday 28th March 2025)"
	revision: "5"

class
	EL_SSH_MIRROR_BACKUP

inherit
	EL_REMOTE_MIRROR_BACKUP
		rename
			element_node_fields as Empty_set
		end

	EL_CHARACTER_32_CONSTANTS

create
	make

feature -- Access

	host: STRING

	user: ZSTRING

	user_host: ZSTRING
		do
			Result := char ('@').joined (user, host)
		end

feature {NONE} -- Implementation

	new_command (backup_target_dir: DIR_PATH): EL_RSYNC_COMMAND_I
		do
			create {EL_RSYNC_COMMAND_IMP} Result.make_ssh_backup (Current)
			Result.archive.enable
			Result.compress.enable
			Result.verbose.enable
		end

end