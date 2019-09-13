note
	description: "Experiments to check behaviour of Eiffel code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-13 15:07:35 GMT (Friday 13th September 2019)"
	revision: "45"

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
			log.enter ("type.conforming_types")
			type.conforming_types
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
