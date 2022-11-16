note
	description: "Cross-platform command to obtain CPU model name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "12"

deferred class
	EL_CPU_INFO_COMMAND_I

inherit
	EL_CAPTURED_OS_COMMAND_I
		rename
			do_with_lines as do_with_output_lines
		export
			{NONE} all
			{EL_MODULE_SYSTEM} template -- for testing
		redefine
			do_with_output_lines
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_NAME_VALUE_PAIR_ROUTINES
		rename
			name as field_name,
			integer as field_integer,
			value as field_value
		export
			{NONE} all
		end

	EL_MODULE_TUPLE

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			make_machine
			create model_name.make_empty
			execute
		end

feature -- Access

	model_name: STRING

	processor_count: INTEGER
		-- number of CPU threads

feature {NONE} -- Implementation

	find_model_name (line: ZSTRING)
		do
			if field_name (line) ~ Field.model_name then
				model_name := field_value (line)
				state := agent find_processors
			end
		end

	find_processors (line: ZSTRING)
		do
			if field_name (line) ~ Field.processors and then attached field_integer (line) as number then
				processor_count := number.item
				state := final
			end
		end

feature {EL_MODULE_SYSTEM} -- Implementation

	field: TUPLE [model_name, processors: ZSTRING]
		deferred
		end

feature {NONE} -- Implementation

	do_with_output_lines (lines: like new_output_lines)
			--
		do
			do_once_with_file_lines (agent find_model_name, lines)
		ensure then
			model_name_set: not model_name.is_empty
			sibling_set: processor_count > 0
		end

end