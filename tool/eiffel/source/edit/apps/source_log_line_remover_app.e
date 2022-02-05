note
	description: "Command line interface to class [$source SOURCE_LOG_LINE_REMOVER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 12:46:44 GMT (Saturday 5th February 2022)"
	revision: "15"

class
	SOURCE_LOG_LINE_REMOVER_APP

inherit
	SOURCE_MANIFEST_SUB_APPLICATION [SOURCE_LOG_LINE_REMOVER_COMMAND]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

feature {NONE} -- Constants

	Option_name: STRING = "log_line_remover"

end