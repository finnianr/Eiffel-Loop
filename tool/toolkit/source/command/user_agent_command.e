note
	description: "[
		List all user agents in web server log file.
		User agents that differ only by version number are merged.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-10 11:51:15 GMT (Monday 10th February 2025)"
	revision: "14"

class
	USER_AGENT_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_WEB_LOG_READER_COMMAND
		redefine
			execute, make_default
		end

	EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_log_path: FILE_PATH)
		do
			make_default
			set_log_path (a_log_path)
		end

	make_default
		do
			Precursor
			create user_agent_set.make_equal (100)
		end

feature -- Constants

	Description: STRING = "List all user agents in web server log file"

feature -- Basic operations

	execute
		do
			Precursor
			if attached user_agent_set.to_list as list then
				list.ascending_sort
				across list as name loop
					lio.put_line (name.item)
				end
			end
		end

feature {NONE} -- Implementation

	do_with (entry: EL_WEB_LOG_ENTRY)
		do
			user_agent_set.put (entry.normalized_user_agent)
		end

feature {NONE} -- Internal attributes

	user_agent_set: EL_HASH_SET [ZSTRING]

end