note
	description: "Command line interface to [$source REGULAR_EXPRESSION_SEARCH_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-18 9:46:26 GMT (Friday 18th February 2022)"
	revision: "4"

class
	REGULAR_EXPRESSION_SEARCH_APP

inherit
	SOURCE_MANIFEST_APPLICATION [REGULAR_EXPRESSION_SEARCH_COMMAND]
		redefine
			argument_list, option_name, visible_types
		end

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		-- for use with when modifiying `argument_specs' in descendant
		do
			Result := Precursor +
				optional_argument ("output", "File to capture grep output", No_checks)
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {FILE_PATH})
		end

	visible_types: TUPLE [
		REGULAR_EXPRESSION_SEARCH_COMMAND
--		EIFFEL_GREP_COMMAND
	]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "grep_search"
end