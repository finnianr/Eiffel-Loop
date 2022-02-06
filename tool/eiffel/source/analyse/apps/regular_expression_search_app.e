note
	description: "Command line interface to [$source REGULAR_EXPRESSION_SEARCH_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-06 16:41:41 GMT (Sunday 6th February 2022)"
	revision: "1"

class
	REGULAR_EXPRESSION_SEARCH_APP

inherit
	SOURCE_MANIFEST_APPLICATION [REGULAR_EXPRESSION_SEARCH_COMMAND]
		redefine
			option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

feature {NONE} -- Constants

	Option_name: STRING = "grep_search"
end