note
	description: "[
		Remove duplicate lines and short commands from bash history file.
		Short means <= 4 characters in length.
	]"
	notes: "[
		**Usage:**
		
			el_toolkit -clean_bash_history
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-22 11:17:21 GMT (Tuesday 22nd October 2024)"
	revision: "1"

class
	CLEAN_BASH_HISTORY_APP

inherit
	EL_APPLICATION

	EL_MODULE_FILE

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
		local
		do
		end

feature {NONE} -- Internal attributes

	file_text: STRING

feature {NONE} -- Constants

	Description: STRING = "Remove duplicate lines and short commands from bash history"
end