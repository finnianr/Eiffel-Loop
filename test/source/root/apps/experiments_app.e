note
	description: "Experiments to check behaviour of Eiffel code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-18 9:49:47 GMT (Friday   18th   October   2019)"
	revision: "46"

class
	EXPERIMENTS_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
		do
			log.enter ("tuple.find_abstract_type")
			tuple.find_abstract_type
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

	type: TYPE_EXPERIMENTS
		do
			create Result
		end

	tuple: TUPLE_EXPERIMENTS
		do
			create Result
		end

feature {NONE} -- Constants

	Description: STRING = "Experiments to check behaviour of Eiffel code"

	Option_name: STRING = "experiments"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{EXPERIMENTS_APP}, All_routines]
			>>
		end
end
