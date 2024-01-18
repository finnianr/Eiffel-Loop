note
	description: "A precursor to ${EL_STANDARD_DIRECTORY_I} prior to April 2020"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 15:16:26 GMT (Sunday 5th November 2023)"
	revision: "5"

deferred class
	EL_LEGACY_DIRECTORY_I

inherit
	EL_OS_DEPENDENT
	
	EXECUTION_ENVIRONMENT
		rename
			environ as environ_table,
			item as environ
		export
			{NONE} all
		end

	EL_MODULE_BUILD_INFO

feature -- Paths

	app_data: DIR_PATH
		-- user application data
		deferred
		end

	app_configuration: DIR_PATH
		-- application configuration data
		deferred
		end

end