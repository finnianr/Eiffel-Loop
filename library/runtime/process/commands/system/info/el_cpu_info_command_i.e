note
	description: "Unix only command to obtain CPU model name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 15:40:28 GMT (Thursday 9th September 2021)"
	revision: "6"

deferred class
	EL_CPU_INFO_COMMAND_I

inherit
	EL_CAPTURED_OS_COMMAND_I
		export
			{NONE} all
		redefine
			do_with_lines
		end

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			execute
		end

feature -- Access

	model_name: STRING

feature {NONE} -- Implementation

	do_with_lines (lines: like adjusted_lines)
			--
		do
			lines.compare_objects
			lines.find_first_true (agent {ZSTRING}.starts_with (Text_model_name))
			if not lines.after then
				model_name := lines.item.substring_end (lines.item.index_of (':', 1) + 2)
			end
		ensure then
			model_name_not_empty: not model_name.is_empty
		end

feature {NONE} -- Constants

	Text_model_name: ZSTRING
		once
			Result := "model name"
		end
end