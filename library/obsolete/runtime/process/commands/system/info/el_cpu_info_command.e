note
	description: "Summary description for {EL_CPU_INFO_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-18 8:52:42 GMT (Saturday 18th June 2016)"
	revision: "1"

class
	EL_CPU_INFO_COMMAND

inherit
	EL_OS_COMMAND [EL_CPU_INFO_COMMAND_IMPL]
		export
			{NONE} all
		redefine
			make_default, Line_processing_enabled, do_with_lines
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			execute
		end

	make_default
		do
			create model_name.make_empty
			Precursor
		end

feature -- Access

	model_name: STRING

feature {NONE} -- Implementation

	Line_processing_enabled: BOOLEAN = true

	do_with_lines (lines: EL_FILE_LINE_SOURCE)
			--
		do
			lines.compare_objects
			lines.find_first (True, agent {ZSTRING}.starts_with (Text_model_name))
			if not lines.after then
				model_name := lines.item.substring (lines.item.index_of (':', 1) + 2, lines.item.count).to_latin_1
			end
		ensure then
			model_name_not_empty: not model_name.is_empty
		end

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

feature {NONE} -- Constants

	Text_model_name: ZSTRING
		once
			Result := "model name"
		end
end