note
	description: "[
		List all user agents in web server log file.
		User agents that differ only by version number are merged.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-27 14:02:53 GMT (Monday 27th March 2023)"
	revision: "9"

class
	USER_AGENT_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_WEB_LOG_PARSER_COMMAND
		redefine
			execute, make
		end

	EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_log_path: FILE_PATH)
		do
			Precursor (a_log_path)
			create user_agent_set.make (100)
		end

feature -- Constants

	Description: STRING = "List all user agents in web server log file"

feature -- Basic operations

	execute
		local
			list: EL_ZSTRING_LIST
		do
			Precursor
			create list.make_from (user_agent_set)
			list.sort
			across list as name loop
				lio.put_line (name.item)
			end
		end

feature {NONE} -- Implementation

	do_with (entry: EL_WEB_LOG_ENTRY)
		do
			user_agent_set.put (entry.versionless_user_agent)
		end

feature {NONE} -- Internal attributes

	user_agent_set: EL_HASH_SET [ZSTRING]

end