note
	description: "[
		${EL_MIRROR_BACKUP} for **file** protocol using ${EL_FILE_RSYNC_COMMAND} command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 15:40:02 GMT (Friday 28th March 2025)"
	revision: "4"

class
	EL_FILE_MIRROR_BACKUP

inherit
	EL_MIRROR_BACKUP
		rename
			element_node_fields as Empty_set
		redefine
			is_mounted
		end

create
	make

feature -- Access

	to_string: ZSTRING
		do
			Result := Url_template #$ [protocol, backup_dir]
		end

feature -- Status query

	is_mounted: BOOLEAN
		do
			Result := backup_dir.parent.exists
		end

feature {NONE} -- Implementation

	new_command (backup_target_dir: DIR_PATH): EL_RSYNC_COMMAND_I
		do
			create {EL_RSYNC_COMMAND_IMP} Result.make_backup (Current)
			Result.archive.enable
			Result.verbose.enable
		end

feature {NONE} -- Constants

	Url_template: ZSTRING
		once
			Result := "%S://%S"
		end
end