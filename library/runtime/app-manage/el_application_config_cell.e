note
	description: "Summary description for {EL_APPLICATION_CONFIG_CELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:01 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_APPLICATION_CONFIG_CELL [G -> {EL_FILE_PERSISTENT} create make, make_from_file end]

inherit
	CELL [G]

	EL_MODULE_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	EL_MODULE_FILE_SYSTEM

create
	make_from_option_name, make, make_from_master

feature {NONE} -- Initialization

	make_from_option_name (a_option_name: STRING)
		do
			Application_sub_option.share (a_option_name)
		end

	make (a_file_name: STRING)
		do
			file_name := a_file_name
			put (create_config (config_file_path))
		end

	make_from_master (a_master_copy_path: EL_FILE_PATH)
		require
			master_copy_exists: a_master_copy_path.exists
		do
			file_name := a_master_copy_path.steps.last
			if config_file_path.exists then
				make (file_name)
			else
				-- Must be the first time application was used
				put (create {G}.make_from_file (a_master_copy_path))
				item.set_file_path (config_file_path)
				item.store
			end
		end

feature {NONE} -- Implementation

	create_config (a_file_path: EL_FILE_PATH): G
		do
			if a_file_path.exists then
				create Result.make_from_file (a_file_path)
			else
				create Result.make
				Result.set_file_path (a_file_path)
				Result.store
			end
		end

	config_file_path: EL_FILE_PATH
			--
		require
			configuration_directory_exists: (Execution_environment.User_configuration_dir.exists)
		local
			l_dir_path: EL_DIR_PATH
		do
			l_dir_path := Execution_environment.User_configuration_dir.twin
			if not Application_sub_option.is_empty then
				l_dir_path.append_file_path (Application_sub_option)
			end
			File_system.make_directory (l_dir_path)
			Result := l_dir_path + file_name
		end

feature -- Access

	file_name: EL_ASTRING

feature {NONE} -- Constants

	Application_sub_option: STRING
		once ("process")
			create Result.make_empty
		end

end