note
	description: "[
		[$source EL_MIRROR_BACKUP] implementing remote protocol such as **ftp** or **ssh**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-25 13:11:20 GMT (Friday 25th August 2023)"
	revision: "1"

deferred class
	EL_REMOTE_MIRROR_BACKUP

inherit
	EL_MIRROR_BACKUP

feature -- Access

	host: STRING
		deferred
		end

	user: ZSTRING
		deferred
		end

	to_string: ZSTRING
		local
			backup_path: ZSTRING
		do
			backup_path := backup_dir.to_unix
			backup_path.prune_all_leading ('/')
			Result := Url_template #$ [protocol, user, host, backup_path]
		end

feature {NONE} -- Constants

	Url_template: ZSTRING
		once
			Result := "%S://%S@%S/%S"
		end

end