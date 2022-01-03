note
	description: "A precursor to [$source EL_STANDARD_DIRECTORY_I] prior to April 2020"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "2"

deferred class
	EL_LEGACY_DIRECTORY_I

inherit
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
