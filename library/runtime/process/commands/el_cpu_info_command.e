note
	description: "Summary description for {EL_CPU_INFO_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_CPU_INFO_COMMAND

inherit
	EL_OS_COMMAND [EL_CPU_INFO_COMMAND_IMPL]
		export
			{NONE} all
		redefine
			make, Line_processing_enabled, do_with_lines
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create model_name.make_empty
			execute
		end

feature -- Access

	model_name: STRING

feature {NONE} -- Implementation

	do_with_lines (lines: EL_FILE_LINE_SOURCE)
			--
		do
			lines.compare_objects
			lines.find_first (True, agent {EL_ASTRING}.starts_with ("model name"))
			if not lines.after then
				model_name := lines.item.substring (lines.item.index_of (':', 1) + 2, lines.item.count)
			end
		ensure then
			model_name_not_empty: not model_name.is_empty
		end

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

	Line_processing_enabled: BOOLEAN = true

end