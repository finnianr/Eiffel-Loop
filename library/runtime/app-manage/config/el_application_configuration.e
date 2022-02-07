note
	description: "Application configuration object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 10:38:49 GMT (Monday 7th February 2022)"
	revision: "8"

deferred class
	EL_APPLICATION_CONFIGURATION

inherit
	EL_FILE_PERSISTENT_I

	EL_SHARED_APPLICATION

	EL_MODULE_DIRECTORY

	EL_APPLICATION_CONSTANTS

	EL_SOLITARY
		redefine
			make
		end

feature {NONE} -- Initialization

	make
		-- if local config file does not exist, use master copy in installation
		-- or else just build the default
		local
			path_list: EL_FILE_PATH_LIST; config_path: FILE_PATH
		do
			Precursor
			config_path := Application.user_config_dir + base_name
			path_list := << config_path, Installation_config_dir + base_name >>
			path_list.find_first_true (agent {FILE_PATH}.exists)
			if path_list.found then
				make_from_file (path_list.path)
			else
				make_default
			end
			set_file_path (config_path)
			if not file_path.exists then
				File_system.make_directory (Application.user_config_dir)
				store
			end
		ensure then
			user_file_exists: file_path.exists
		end

	make_default
		deferred
		end

feature -- Element change

	reload
		do
			make_from_file (file_path)
		end

feature {NONE} -- Implementation

	base_name: ZSTRING
		deferred
		end

	installation_config_dir: DIR_PATH
		do
			Result := Directory.Application_installation.joined_dir_tuple ([Standard_option.config, Application.option_name])
		end

end