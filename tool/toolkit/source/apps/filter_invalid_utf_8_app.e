note
	description: "[
		Sub-application to Filter out all invalid UTF-8 lines from file
		See class [$source FILTER_INVALID_UTF_8] for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	FILTER_INVALID_UTF_8_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [FILTER_INVALID_UTF_8]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("in", "Input file path", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, FILTER_INVALID_UTF_8]
			--
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "filter_utf_8"

end