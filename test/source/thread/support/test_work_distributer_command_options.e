note
	description: "Test work distributer command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 9:38:16 GMT (Monday 20th January 2020)"
	revision: "5"

class
	TEST_WORK_DISTRIBUTER_COMMAND_OPTIONS

inherit
	EL_APPLICATION_COMMAND_OPTIONS
		redefine
			Help_text, initialize_fields
		end

create
	make, make_default

feature {NONE} -- Initialization

	initialize_fields
		do
			delta_count := 10000
			repetition_count := 1
			task_count := 4
			term_count := 4
			thread_count := 4
		end

feature -- Access

	delta_count: INTEGER

	repetition_count: INTEGER

	task_count: INTEGER

	term_count: INTEGER

	thread_count: INTEGER

	max_priority: BOOLEAN

	priority_name: STRING
		do
			if max_priority then
				Result := "maximum"
			else
				Result := "normal"
			end
		end

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := joined (Precursor, "[
				delta_count:
					Number of integral range "split intervals" to calculate
				max_priority:
					Use maximum priority threads
				repetition_count:
					Number of repetitions of each calculation to do
				task_count:
					Number of discreet tasks to divide integral calculation into for thread assignation
				term_count:
					Number of sine functions to add together for test function
				thread_count:
					Number of threads to use to calculate integral of test sine function
			]")
		end

end
