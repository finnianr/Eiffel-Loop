note
	description: "Experiments to check behaviour of Eiffel code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-22 15:51:39 GMT (Tuesday 22nd February 2022)"
	revision: "81"

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
			log.enter ("")
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

	compile_various: TUPLE [
		EL_TEST_SET_BRIDGE, LIBGCC1, MY_WET_CLASS, MY_DRY_CLASS
	]
		do
			create Result
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Description: STRING = "Experiments to check behaviour of Eiffel code"

end