note
	description: "A precursor to [$source EL_STANDARD_DIRECTORY_I] prior to April 2020"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 12:58:57 GMT (Sunday 19th April 2020)"
	revision: "1"

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

	app_data: EL_DIR_PATH
		-- user application data
		deferred
		end

	app_configuration: EL_DIR_PATH
		-- application configuration data
		deferred
		end

end
