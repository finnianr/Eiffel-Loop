note
	description: "Experiments to check behaviour of Eiffel code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 17:36:33 GMT (Thursday 10th February 2022)"
	revision: "78"

class
	EXPERIMENTS_APP

inherit
	EL_LOGGED_APPLICATION

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
		do
			log.enter ("file.print_os_user_list")
			file.print_os_user_list
			log.exit
		end

feature {NONE} -- Experiments

	agent_routine: AGENT_EXPERIMENTS
		do
			create Result
		end

	date_time: DATE_TIME_EXPERIMENTS
		do
			create Result
		end

	file: FILE_EXPERIMENTS
		do
			create Result
		end

	general: GENERAL_EXPERIMENTS
		do
			create Result
		end

	numeric: NUMERIC_EXPERIMENTS
		do
			create Result
		end

	string: STRING_EXPERIMENTS
		do
			create Result
		end

	structure: STRUCTURE_EXPERIMENTS
		do
			create Result
		end

	syntax: SYNTAX_EXPERIMENTS
		do
			create Result
		end

	tuple: TUPLE_EXPERIMENTS
		do
			create Result
		end

	type: TYPE_EXPERIMENTS
		do
			create Result
		end

feature {NONE} -- Implementation

	log_filter_set: EL_LOG_FILTER_SET [like Current]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Description: STRING = "Experiments to check behaviour of Eiffel code"

end