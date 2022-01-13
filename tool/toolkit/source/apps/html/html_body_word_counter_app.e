note
	description: "[
		A command line interface to the [$source HTML_BODY_WORD_COUNTER] class.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 11:40:08 GMT (Thursday 13th January 2022)"
	revision: "19"

class
	HTML_BODY_WORD_COUNTER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [HTML_BODY_WORD_COUNTER]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("path", "Directory path")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (Directory.Current_working)
		end

feature {NONE} -- Constants

	Option_name: STRING = "body_word_counts"

end