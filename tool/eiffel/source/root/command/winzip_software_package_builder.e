note
	description: "[
		Command to build an application and then package it as a self-extracting winzip exe installer.
	]"
	notes: "[
		Requires that the WinZip command-line utility `wzipse32' is installed and in the search path.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-06 18:07:38 GMT (Friday 6th August 2021)"
	revision: "15"

class
	WINZIP_SOFTWARE_PACKAGE_BUILDER

inherit
	EL_COMMAND

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_config_path, a_pecf_path: EL_FILE_PATH)
		require
			path_exists: a_config_path.exists
			path_exists: a_pecf_path.exists
		do
			create package.make (a_config_path, a_pecf_path)
		end

feature -- Basic operations

	execute
		do
			package.build
		end

feature {NONE} -- Implementation: attributes

	package: WINZIP_SOFTWARE_PACKAGE

end