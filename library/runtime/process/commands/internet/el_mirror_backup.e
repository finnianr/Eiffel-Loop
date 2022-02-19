note
	description: "[
		Backup mirroring for protocols ''ftp'', ''ssh'' or ''file'' using utilities: ''rsync' and ''lftp''
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 15:30:59 GMT (Saturday 19th February 2022)"
	revision: "5"

class
	EL_MIRROR_BACKUP

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make,
			xml_names as export_default,
			element_node_fields as Empty_set
		end

	EL_PROTOCOL_CONSTANTS
		rename
			Protocol as Protocols
		end

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_MODULE_TUPLE

create
	make

feature -- Access

	backup_dir: DIR_PATH

	host_name: STRING

	passphrase: ZSTRING
		do
			Result := Passphrase_table [host_name]
		end

	protocol: STRING

	to_string: ZSTRING
		local
			template: ZSTRING
		do
			if protocol ~ Protocols.ssh or protocol ~ Protocols.ftp then
				template := "%S://%S@%S/%S"
				Result := template #$ [protocol, user, host_name, backup_dir]
			else
				template := "%S://%S"
				Result := template #$ [protocol, backup_dir]
			end
		end

	user: ZSTRING

feature -- Status query

	has_error: BOOLEAN

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
			if not Passphrase_table.has (host_name) and then protocol ~ Protocols.ftp then
				prompt_template := "Enter %S ftp password"
				Passphrase_table [host_name] := User_input.line (prompt_template #$ [host_name])
				lio.put_new_line
			end
		end

	transfer (backup_target_dir: DIR_PATH)
		do
			if protocol ~ Protocols.ftp and then attached Ftp_command as cmd then
				cmd.set_host_name (host_name)
				cmd.set_user (user)
				cmd.set_passphrase (passphrase)
--				-- Directories not escaped because they are single quoted in template
				cmd.set_source_dir (backup_target_dir)
				cmd.set_target_dir (backup_dir #+ backup_target_dir.base)
				execute (cmd)

			elseif protocol ~ Protocols.file and then attached Rsync_file_command as cmd then
				cmd.put_path (Var_file.source_dir, backup_target_dir)
				cmd.put_path (Var_file.target_dir, backup_dir)
				execute (cmd)

			elseif protocol ~ Protocols.ssh and then attached Rsync_ssh_command as cmd then
				cmd.put_string (Var_ssh.user, user)
				cmd.put_string (Var_ssh.host, host_name)
				cmd.put_path (Var_ssh.source_dir, backup_target_dir)
				cmd.put_path (Var_ssh.target_dir, backup_dir)
				execute (cmd)

			else
				lio.put_labeled_string ("Unknown protocol", protocol)
				lio.put_new_line
				has_error := True
			end
		end

feature {NONE} -- Implementation

	execute (cmd: EL_OS_COMMAND_I)
		do
			cmd.execute
			has_error := cmd.has_error
		end

feature {NONE} -- Constants

	Passphrase_table: HASH_TABLE [ZSTRING, STRING]
		once
			create Result.make (3)
		end

	Ftp_command: EL_FTP_MIRROR
		once
			create Result.make
		end

	Rsync_file_command: EL_OS_COMMAND
		once
			create Result.make ("rsync -av $SOURCE_DIR $TARGET_DIR")
		end

	Rsync_ssh_command: EL_OS_COMMAND
		once
			create Result.make ("rsync -avz -e ssh $SOURCE_DIR $USER@$HOST:$TARGET_DIR")
		end

	Var_ssh: TUPLE [source_dir, user, host, target_dir: STRING]
		once
			create Result
			Rsync_ssh_command.fill_variables (Result)
		end

	Var_file: TUPLE [source_dir, target_dir: STRING]
		once
			create Result
			Rsync_file_command.fill_variables (Result)
		end
end