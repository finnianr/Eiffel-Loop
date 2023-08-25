note
	description: "[
		[$source EL_MIRROR_BACKUP] for **file** protocol using [$source EL_RSYNC_COMMAND] command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-25 17:39:36 GMT (Friday 25th August 2023)"
	revision: "1"

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

	new_command (backup_target_dir: DIR_PATH): EL_FILE_RSYNC_COMMAND
		do
			create Result.make (Current)
		end

feature {NONE} -- Constants

	Url_template: ZSTRING
		once
			Result := "%S://%S"
		end
end