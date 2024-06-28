note
	description: "Application configuration object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-27 14:23:55 GMT (Thursday 27th June 2024)"
	revision: "11"

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
			path_list: EL_FILE_PATH_LIST
		do
			Precursor
			if attached (config_dir + base_name) as config_path then
				path_list := << config_path, Installation_config_dir + base_name >>
				path_list.find_first_true (agent {FILE_PATH}.exists)
				if path_list.found then
					make_from_file (path_list.path)
				else
					make_default
				end
				set_file_path (config_path)
			end
			if not file_path.exists then
				File_system.make_directory (config_dir)
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

feature -- Status query

	is_shared: BOOLEAN
		-- when `True' the configuration is shared between sub-applications
		do
			Result := False
		end

feature {NONE} -- Implementation

	base_name: ZSTRING
		deferred
		end

	config_dir: DIR_PATH
		do
			if is_shared then
				Result := Directory.app_configuration
			else
				Result := Application.user_config_dir
			end
		end

	installation_config_dir: DIR_PATH
		local
			t: TUPLE
		do
			if is_shared then
				t := [Standard_option.config]
			else
				t := [Standard_option.config, Application.option_name]
			end
			Result := Directory.Application_installation.joined_dir_tuple (t)
		end

end