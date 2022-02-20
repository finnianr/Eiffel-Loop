note
	description: "Unix only command to obtain CPU model name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 12:17:20 GMT (Sunday 20th February 2022)"
	revision: "8"

deferred class
	EL_CPU_INFO_COMMAND_I

inherit
	EL_CAPTURED_OS_COMMAND_I
		rename
			do_with_lines as do_with_output_lines
		export
			{NONE} all
		redefine
			do_with_output_lines
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		redefine
			call
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

	siblings: INTEGER
		-- number of CPU threads

feature {NONE} -- Implementation

	find_model_name (line: ZSTRING)
		local
			colon: EL_COLON_FIELD_ROUTINES
		do
			if colon.name (line) ~ Field.model_name then
				model_name := colon.value (line)
				state := agent find_siblings
			end
		end

	find_siblings (line: ZSTRING)
		local
			colon: EL_COLON_FIELD_ROUTINES
		do
			if colon.name (line) ~ Field.siblings and then attached colon.integer (line) as number then
				siblings := number.item
				state := final
			end
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		-- call state procedure with item
		do
			if attached line.substring_to (':', default_pointer) as name then
				line.remove_head (name.count)
				name.right_adjust
				line.prepend (name)
			end
			state (line)
		end

	do_with_output_lines (lines: like new_output_lines)
			--
		do
			do_once_with_file_lines (agent find_model_name, lines)
		ensure then
			model_name_set: not model_name.is_empty
			sibling_set: siblings > 0
		end

feature {NONE} -- Constants

	Field: TUPLE [model_name, siblings: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "model name, siblings")
		end
end