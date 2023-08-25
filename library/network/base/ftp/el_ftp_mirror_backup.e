note
	description: "[
		[$source EL_MIRROR_BACKUP] for **ftp** protocol using [$source EL_FTP_MIRROR_COMMAND] command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-25 18:00:06 GMT (Friday 25th August 2023)"
	revision: "1"

class
	EL_FTP_MIRROR_BACKUP

inherit
	EL_REMOTE_MIRROR_BACKUP
		redefine
			authenticate
		end

create
	make

feature -- Access

	domain: STRING

	host: STRING
		do
			Result := site.url.host
		end

	user: ZSTRING
		do
			Result := site.url.username
		end

	passphrase: ZSTRING
		do
			if Url_table.has_key (url_key)  then
				Result := Url_table.found_item.password
			else
				create Result.make_empty
			end
		end

feature -- Basic operations

	authenticate
		do
			if Url_table.has_key (url_key) then
				site.url.copy (Url_table.found_item)
			else
				lio.put_labeled_string ("ftp", domain)
				lio.put_new_line
				site.authenticate (Void)
				Url_table [url_key] := site.url
			end
		end

feature {NONE} -- Implementation

	new_command (backup_target_dir: DIR_PATH): EL_FTP_MIRROR_COMMAND
		do
			create Result.make (Current)
			Result.set_target_dir (backup_dir #+ backup_target_dir.base)
		end

	url_key: STRING
		do
			Result := site.credential.digest_base_64
		end

feature {NONE} -- Internal attributes

	site: EL_FTP_CONFIGURATION

feature {NONE} -- Constants

	Element_node_fields: STRING = "site"

	Url_table: HASH_TABLE [FTP_URL, STRING]
		once
			create Result.make (3)
		end

end