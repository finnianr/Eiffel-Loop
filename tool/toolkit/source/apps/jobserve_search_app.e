note
	description: "Command line interface to [$source JOBSERVE_SEARCHER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-09 10:13:26 GMT (Tuesday 9th March 2021)"
	revision: "14"

class
	JOBSERVE_SEARCH_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [JOBSERVE_SEARCHER]
		redefine
			option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("input", "Jobserve XML input data", << file_must_exist >>),
				valid_optional_argument ("output", "Output directory for results file", << directory_must_exist >>),
				optional_argument ("filter", "xpath filter condition")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH}, create {EL_DIR_PATH}, "")
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, JOBSERVE_SEARCHER]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Description: STRING = "Search Jobserve XML for short contracts"

--	Ask_user_to_quit: BOOLEAN is true

	Option_name: STRING = "jobserve"

end