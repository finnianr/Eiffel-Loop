note
	description: "Summary description for {EL_CPU_INFO_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-19 11:20:32 GMT (Sunday 19th June 2016)"
	revision: "5"

deferred class
	EL_CPU_INFO_COMMAND_I

inherit
	EL_CAPTURED_OS_COMMAND_I
		export
			{NONE} all
		redefine
			make_default, do_with_lines
		end

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

	do_with_lines (lines: like adjusted_lines)
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