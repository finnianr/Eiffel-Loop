note
	description: "[
		Backup mirroring for protocols **ftp**, **ssh** or **file** using Unix commands **rsync** and **lftp**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 10:15:51 GMT (Thursday 16th June 2022)"
	revision: "9"

class
	EL_MIRROR_BACKUP

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			element_node_fields as Empty_set,
			xml_naming as eiffel_naming
		end

	EL_PROTOCOL_CONSTANTS
		rename
			Protocol as Protocols
		end

	EL_MODULE_LIO; EL_MODULE_USER_INPUT

create
	make

feature -- Access

	backup_dir: DIR_PATH

	errors: EL_ZSTRING_LIST

	host_name: STRING

	passphrase: ZSTRING
		do
			if Passphrase_table.has_key (host_name)  then
				Result := Passphrase_table.found_item
			else
				create Result.make_empty
			end
		end

	protocol: STRING

	to_string: ZSTRING
		local
			template, backup_path: ZSTRING
		do
			if protocol ~ Protocols.ssh or protocol ~ Protocols.ftp then
				backup_path := backup_dir.to_unix
				backup_path.prune_all_leading ('/')
				template := "%S://%S@%S/%S"
				Result := template #$ [protocol, user, host_name, backup_path]
			else
				template := "%S://%S"
				Result := template #$ [protocol, backup_dir]
			end
		end

	user: ZSTRING

feature -- Status query

	has_error: BOOLEAN
		do
			Result := errors.count > 0
		end

	is_file: BOOLEAN
		do
			Result := protocol ~ Protocols.file
		end

	is_mounted: BOOLEAN
		do
			Result := is_file implies backup_dir.parent.exists
		end

feature -- Basic operations

	set_passphrase
		local
			prompt_template: ZSTRING
		do
			if protocol ~ Protocols.ftp and then not Passphrase_table.has (host_name) then
				prompt_template := "Enter %S ftp password"
				Passphrase_table [host_name] := User_input.line (prompt_template #$ [host_name])
				lio.put_new_line
			end
		end

	transfer (backup_target_dir: DIR_PATH)
		local
			cmd: EL_MIRROR_COMMAND
		do
			if Command_table.has_key (protocol) then
				cmd := Command_table.found_item
				cmd.set_host (host_name)
				cmd.set_user (user)
				cmd.set_passphrase (passphrase)
				cmd.set_source_dir (backup_target_dir)

				if attached {EL_FTP_MIRROR_COMMAND} cmd then
					cmd.set_target_dir (backup_dir #+ backup_target_dir.base)
				else
					cmd.set_target_dir (backup_dir)
				end
				cmd.execute -- EXECUTE

				if cmd.has_error then
					errors.append (cmd.errors)
				else
					errors.wipe_out
				end
			else
				errors.extend ("Unknown protocol:" + protocol)
			end
		end

feature {NONE} -- Constants

	Passphrase_table: HASH_TABLE [ZSTRING, STRING]
		once
			create Result.make (3)
		end

	Command_table: HASH_TABLE [EL_MIRROR_COMMAND, STRING]
		once
			create Result.make (3)
			Result [Protocols.file] := create {EL_RSYNC_COMMAND}.make
			Result [Protocols.ftp] := create {EL_FTP_MIRROR_COMMAND}.make
			Result [Protocols.ssh] := create {EL_RSYNC_SSH_COMMAND}.make
		end

end