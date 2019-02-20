note
	description: "Application config cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-20 12:14:18 GMT (Wednesday 20th February 2019)"
	revision: "10"

class
	EL_APPLICATION_CONFIG_CELL [G -> {EL_FILE_PERSISTENT_I} create make_from_file end]

inherit
	CELL [G]

	EL_MODULE_DIRECTORY
		export
			{NONE} all
		end

	EL_MODULE_FILE_SYSTEM
		export
			{NONE} all
		end

	EL_SHARED_APPLICATION_OPTION_NAME

create
	make, make_from_master

feature {NONE} -- Initialization

	make (a_file_name: like file_name)
		do
			file_name := a_file_name
			put (create {G}.make_from_file (config_file_path))
		end

	make_from_master (a_master_copy_path: EL_FILE_PATH)
		require
			master_copy_exists: a_master_copy_path.exists
		do
			file_name := a_master_copy_path.base
			if config_file_path.exists then
				make (file_name)
			else
				-- Must be the first time application was used
				put (create {G}.make_from_file (a_master_copy_path))
				item.set_file_path (config_file_path)
				item.store
			end
		end

feature -- Access

	config_file_path: EL_FILE_PATH
			--
		require
			configuration_directory_exists: configuration_directory_exists
		local
			l_dir_path: EL_DIR_PATH
		do
			l_dir_path := Directory.App_configuration.twin
			if not Application_option_name.is_empty then
				l_dir_path.append_file_path (Application_option_name)
			end
			File_system.make_directory (l_dir_path)
			Result := l_dir_path + file_name
		end

	file_name: ZSTRING

feature -- Status query

	configuration_directory_exists: BOOLEAN
		do
			Result := Directory.App_configuration.exists
		end

feature -- Element change

	update
		require
			config_file_path_exits: config_file_path.exists
		do
			make (file_name)
		end


end
