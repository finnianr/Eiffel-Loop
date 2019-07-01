note
	description: "Application configuration object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-12 15:33:27 GMT (Wednesday 12th June 2019)"
	revision: "3"

deferred class
	EL_APPLICATION_CONFIGURATION

inherit
	EL_FILE_PERSISTENT_I

	EL_SHARED_APPLICATION_OPTION_NAME

	EL_MODULE_DIRECTORY

feature {NONE} -- Initialization

	make
		-- if local config file does not exist, use master copy in installation
		-- or else just build the default
		local
			config_path: EL_FILE_PATH
		do
			config_path := user_dir + base_name
			if config_path.exists then
				make_from_file (config_path)
			else
				config_path := Installation_config_dir + base_name
				if config_path.exists then
					make_from_file (config_path)
				else
					make_default
				end
			end
			set_file_path (User_dir + base_name)
			if not file_path.exists then
				File_system.make_directory (User_dir)
				store
			end
		ensure
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

feature {NONE} -- Constants

	Installation_config_dir: EL_DIR_PATH
		once
			Result := Directory.Application_installation.twin
			Result.append_step ("config")
		end

	User_dir: EL_DIR_PATH
		once
			Result := Directory.App_configuration.twin
			if not Application_option_name.is_empty then
				Result.append_step (Application_option_name)
			end
		end

end
