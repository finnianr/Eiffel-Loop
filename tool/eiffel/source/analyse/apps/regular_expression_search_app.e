note
	description: "Command line interface to [$source REGULAR_EXPRESSION_SEARCH_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-17 15:59:49 GMT (Thursday 17th February 2022)"
	revision: "3"

class
	REGULAR_EXPRESSION_SEARCH_APP

inherit
	SOURCE_MANIFEST_APPLICATION [REGULAR_EXPRESSION_SEARCH_COMMAND]
		redefine
			option_name, visible_types
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

	compile: TUPLE [DISTRIBUTED_REGULAR_EXPRESSION_SEARCH_COMMAND]
		do
			create Result
		end

	visible_types: TUPLE [REGULAR_EXPRESSION_SEARCH_COMMAND]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "grep_search"
end