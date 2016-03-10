note
	description: "Summary description for {JOB_DURATION_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-04-14 11:29:18 GMT (Monday 14th April 2014)"
	revision: "4"

class
	JOB_DURATION_PARSER

feature {NONE} -- Patterns

	year_word: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				string_literal ("año"),
			>>)
		end

end
