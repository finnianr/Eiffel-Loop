note
	description: "Summary description for {EL_FIND_DIRECTORIES_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_FIND_DIRECTORIES_COMMAND_I

inherit
	EL_FIND_COMMAND_I

feature {NONE} -- Implementation

	new_path (a_path: ZSTRING): EL_DIR_PATH
		do
			create Result.make (a_path)
		end

feature {NONE} -- Constants

	Type: STRING = "d"
			-- Unix find type

end