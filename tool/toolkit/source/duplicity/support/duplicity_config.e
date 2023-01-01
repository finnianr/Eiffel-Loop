note
	description: "Duplicity configuration buildable from a Pyxis file"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 9:10:43 GMT (Saturday 31st December 2022)"
	revision: "16"

deferred class
	DUPLICITY_CONFIG

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		export
			{EL_COMMAND_CLIENT} make
		redefine
			make_default
		end

	EL_PROTOCOL_CONSTANTS
		export
			{NONE} all
		end

	EL_SHARED_OPERATING_ENVIRON

	EL_ZSTRING_CONSTANTS

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_LIO

	EL_MODULE_OS

	EL_MODULE_USER_INPUT

	EL_MODULE_DATE

feature {NONE} -- Initialization

	make_default
		do
			create encryption_key.make_empty
			create backup_dir
			change_text := True
			create name.make_empty
			create mirror_list.make (5)
			create pre_backup_command.make_empty
			create restore_dir
			create target_dir
			create exclude_any_list.make_empty
			create exclude_files_list.make_empty
			Precursor
		end

feature -- Access

	backup_dir: DIR_PATH

	encryption_key: ZSTRING

	exclude_any_list: EL_ZSTRING_LIST

	exclude_files_list: EL_ZSTRING_LIST

	mirror_list: EL_ARRAYED_LIST [EL_MIRROR_BACKUP]

	name: ZSTRING
		-- possible alias for `target_dir.base' used as backup destination

	pre_backup_command: ZSTRING

	restore_dir: DIR_PATH

	target_dir: DIR_PATH

	target_dir_base: ZSTRING
		-- `target_dir.base' or an alias `name'
		do
			if name.is_empty then
				Result := target_dir.base
			else
				Result := name
			end
		end

feature -- Status query

	change_text: EL_BOOLEAN_OPTION

feature {NONE} -- Build from XML

	append_exclude_any
		do
			create exclude_any_list.make_with_lines (node.to_string)
		end

	append_exclude_files
		local
			parent_dir: ZSTRING
		do
			create exclude_files_list.make_with_lines (node.to_string)
			parent_dir := target_dir.base #+ [Operating_environ.Directory_separator]

			across exclude_files_list as file loop
				file.item.prepend_string (parent_dir)
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@backup_dir",				agent do backup_dir := node.to_expanded_dir_path end],
				["@change_text_enabled",	agent do change_text := node.adjusted_8 (False).as_lower ~ "true" end],
				["@encryption_key",			agent do encryption_key := node end],
				["@name",						agent do name := node end],
				["@pre_backup_command",		agent do pre_backup_command := node end],
				["@restore_dir",				agent do restore_dir := node.to_expanded_dir_path end],
				["@target_dir",				agent do target_dir := node.to_expanded_dir_path end],

				["mirror",						agent do set_collection_context (mirror_list, create {EL_MIRROR_BACKUP}.make) end],
				["exclude-any/text()",		agent append_exclude_any],
				["exclude-files/text()",	agent append_exclude_files]
			>>)
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "duplicity"

	Var_target_dir: STRING = "target_dir"

note
	notes: "[
		A typical configuration file is shown below. The configuration `name' is optional and defaults to
		the base of the `target_dir'. This name is used to name the backup directory name. All `exclude-files'
		entries are relative to the `target_dir'.

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			duplicity:
				name = "My Ching server"; encryption_key = VAL
				restore_dir = "$HOME/Backups-restored"; backup_dir = "$HOME/Backups/duplicity"
				
				mirror:
					protocol = file; backup_dir = "/media/finnian/Seagate-1/Backups/duplicity"
				mirror:
					protocol = ftp; user = "eiffel-loop.com"; host_name = "ftp.eiffel-loop.com"
					backup_dir = "/htdocs/Backups/duplicity"
				mirror:
					protocol = ssh; user = "finnian"; host_name = "myching.software"
					backup_dir = "$HOME/Backups/duplicity"

				exclude-files:
					"""
						resources/locale.??
						www/images
					"""
				exclude-any:
					"""
						**/build
						**/workarea
						**/.sconf_temp
						**.a
						**.la
						**.lib
						**.obj
						**.o
						**.exe
						**.pyc
						**.evc
						**.dblite
						**.deps
						**.pdb
						**.zip
						**.tar.gz
						**.lnk
						**.goutputstream**
					"""

	]"

end