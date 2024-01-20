note
	description: "[
		${EL_MIRROR_BACKUP} implementing remote protocol such as **ftp** or **ssh**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "2"

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