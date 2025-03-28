note
	description: "[
		${EL_MIRROR_BACKUP} for **ftp** protocol using ${EL_FTP_MIRROR_COMMAND} command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 15:39:44 GMT (Friday 28th March 2025)"
	revision: "7"

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

	credential: EL_AES_CREDENTIAL
		do
			Result := site.credential
		end

	domain: STRING

	host: STRING
		do
			Result := site.url.host
		end

	passphrase: ZSTRING
		do
			if Url_table.has_key (url_key)  then
				Result := Url_table.found_item.password
			else
				create Result.make_empty
			end
		end

	user: ZSTRING
		do
			Result := site.url.username
		end

feature -- Element change

	try_authenticate (a_phrase: ZSTRING)
		do
			site.authenticate (a_phrase)
			Url_table [url_key] := site.url
		end

feature -- Basic operations

	authenticate
		do
			if Url_table.has_key (url_key) then
				site.url.copy (Url_table.found_item)
			else
				if is_lio_enabled then
					lio.put_labeled_string ("ftp", domain)
					lio.put_new_line
				end
				site.authenticate (Void)
				Url_table [url_key] := site.url
			end
		end

feature {NONE} -- Implementation

	new_command (backup_target_dir: DIR_PATH): EL_FTP_COPY_TREE_COMMAND_I
		do
			create {EL_FTP_COPY_TREE_COMMAND_IMP} Result.make_backup (Current, backup_target_dir.base)
		end

	url_key: STRING
		do
			Result := site.credential.target_base_64
		end

feature {NONE} -- Internal attributes

	site: EL_FTP_CONFIGURATION

feature {NONE} -- Constants

	Element_node_fields: STRING = "site"

	Url_table: EL_HASH_TABLE [FTP_URL, STRING]
		once
			create Result.make (3)
		end

end