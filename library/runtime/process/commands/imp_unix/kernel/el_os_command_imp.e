note
	description: "Unix implementation of [$source EL_OS_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-05 13:53:58 GMT (Tuesday 5th March 2019)"
	revision: "5"

deferred class
	EL_OS_COMMAND_IMP

inherit
	EL_OS_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	new_output_lines (file_path: EL_FILE_PATH): EL_LINEAR [ZSTRING]
		do
			if file_path.exists then
				create {EL_PLAIN_TEXT_LINE_SOURCE} Result.make (file_path)
			else
				create {EL_ZSTRING_LIST} Result.make_empty
			end
		end

feature {NONE} -- Constants

	Command_prefix: STRING_32
		once
			create Result.make_empty
		end

end
