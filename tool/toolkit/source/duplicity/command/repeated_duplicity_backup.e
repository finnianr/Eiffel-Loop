note
	description: "Do one or many executions of [$source DUPLICITY_BACKUP] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 14:41:37 GMT (Saturday 19th February 2022)"
	revision: "1"

class
	REPEATED_DUPLICITY_BACKUP

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_LIO; EL_MODULE_OS

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path_or_wildcard: FILE_PATH)
		require
			valid_config_path: not config_path_or_wildcard.is_pattern implies config_path_or_wildcard.exists
		do
			config_list := OS.one_or_many_file_list (config_path_or_wildcard)
		end

feature -- Constants

	Description: STRING = "Do one or many executions of DUPLICITY_BACKUP command]"

feature -- Basic operations

	execute
		local
			backup: DUPLICITY_BACKUP
		do
			across config_list as list loop
				lio.put_labeled_string ("Reading configuration", list.item.base)
				lio.put_new_line
				create backup.make (list.item)
				backup.execute
			end
		end

feature {NONE} -- Internal attributes

	config_list: EL_FILE_PATH_LIST

end