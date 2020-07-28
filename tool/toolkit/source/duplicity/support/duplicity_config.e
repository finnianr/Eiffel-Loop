note
	description: "Duplicity configuration buildable from a Pyxis file"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-29 14:50:28 GMT (Friday 29th May 2020)"
	revision: "5"

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
			create name.make_empty
			create destination_dir_list.make (5)
			create restore_dir
			create target_dir
			create exclude_any_list.make_empty
			create exclude_files_list.make_empty
			Precursor
		end

feature -- Access

	destination_dir_list: EL_ARRAYED_LIST [EL_DIR_URI_PATH]

	encryption_key: ZSTRING

	exclude_any_list: EL_ZSTRING_LIST

	exclude_files_list: EL_ZSTRING_LIST

	name: ZSTRING
		-- possible alias for `target_dir.base' used as backup destination

	restore_dir: EL_DIR_PATH

	target_dir: EL_DIR_PATH

	target_dir_base: ZSTRING
		-- `target_dir.base' or an alias `name'
		do
			if name.is_empty then
				Result := target_dir.base
			else
				Result := name
			end
		end

feature {NONE} -- Build from XML

	append_destination_dir
		local
			steps: EL_PATH_STEPS
		do
			steps := node.to_string
			steps.expand_variables
			destination_dir_list.extend (steps.to_string)
		end

	append_exclude_any
		do
			create exclude_any_list.make_with_lines (node.to_string)
		end

	append_exclude_files
		local
			parent_dir: ZSTRING
		do
			create exclude_files_list.make_with_lines (node.to_string)
			parent_dir := target_dir.base + character_string (Operating_environ.Directory_separator)

			across exclude_files_list as file loop
				file.item.prepend_string (parent_dir)
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@encryption_key",			agent do encryption_key := node end],
				["@name",						agent do name := node end],
				["@target_dir",				agent do target_dir := node.to_expanded_dir_path end],
				["@restore_dir",				agent do restore_dir := node.to_expanded_dir_path end],

				["destination/text()",		agent append_destination_dir],
				["exclude-any/text()",		agent append_exclude_any],
				["exclude-files/text()",	agent append_exclude_files]
			>>)
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "duplicity"

note
	notes: "[
		A typical configuration file is shown below. The configuration `name' is optional and defaults to
		the base of the `target_dir'. This name is used to name the backup directory name. All `exclude-files'
		entries are relative to the `target_dir'.

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			duplicity:
				name = "My Ching server"; encryption_key = VAL
				target_dir = "$HOME/dev/Eiffel/myching-server"
				destination:
					"file://$HOME/Backups/duplicity"
					"file:///media/finnian/Seagate-1/Backups/duplicity"
					"ftp://username@ftp.eiffel-loop.com/public/www/Backups/duplicity"
					"sftp://finnian@18.14.67.44/$HOME/Backups/duplicity"

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
