note
	description: "Menu of compressed logs to analyze"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-28 8:56:28 GMT (Tuesday 28th June 2022)"
	revision: "1"

class
	EL_TRAFFIC_ANALYSIS_SHELL_MENU

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		end

	EL_MODULE_OS

	EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH)
		require
			config_exists: config_path.exists
		do
			create config.make (config_path)
			make_shell ("LOG MENU", 10)
		end

feature -- Constants

	Description: STRING = "Command shell for selecting log file to do traffic analysis"

feature {NONE} -- Commands

	remove_prefix
		do
		end

	rename_classes
		do
		end

feature {NONE} -- Implementation



feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Rename classes",	agent rename_classes],
				["Remove prefix", 	agent remove_prefix]
			>>)
		end

feature {NONE} -- Internal attributes

	config: EL_TRAFFIC_ANALYSIS_CONFIG
end