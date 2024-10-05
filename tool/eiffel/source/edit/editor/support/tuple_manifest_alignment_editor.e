note
	description: "[
		Align the right columns of an array of name-value tuples in some ${EDITABLE_SOURCE_LINES} so the
		value item is left-justified.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 11:08:19 GMT (Friday 4th October 2024)"
	revision: "10"

class
	TUPLE_MANIFEST_ALIGNMENT_EDITOR

inherit
	EL_ARRAYED_LIST [MANIFEST_TUPLE_LINE]
		rename
			append as list_append,
			make as make_sized
		export
			{NONE} all
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			copy, is_equal
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_machine
			make_sized (20)
		end

feature -- Basic operations

	edit (lines: EDITABLE_SOURCE_LINES)
		do
			do_with_lines (agent find_manifest_start, lines)
		end

feature {NONE} -- Line states

	find_manifest_end (line: ZSTRING)
		local
			tuple_line: like item; target_column: INTEGER
		do
			if line.ends_with (Manifest.array_end) then
				target_column := max_integer (agent {like item}.comma_column) + 1

				if target_column > 1 then
					do_all (agent {like item}.align (target_column))
				end
				state := agent find_manifest_start

			else
				create tuple_line.make (line)
				if tuple_line.comma_index > 0 then
					extend (tuple_line)
				end
			end
		end

	find_manifest_start (line: ZSTRING)
		local
			index_lbracket, index_array_start: INTEGER
		do
			index_lbracket := line.index_of ('(', 1)
			if index_lbracket > 0 then
				index_array_start := line.substring_index (Manifest.array_start, index_lbracket + 1)
				if index_array_start > 0 and then index_array_start + 1 = line.count then
					wipe_out
					state := agent find_manifest_end
				end
			end
		end

feature {NONE} -- Constants

	Manifest: TUPLE [array_start, array_end: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "<<, >>)")
		end

note
	notes: "[
		Unaligned tuple array:

			Getter_functions: EVOLICITY_GETTER_FUNCTION_TABLE
					--
				once
					create Result.make (<<
						["input_file_path", agent get_input_file_path],
						["output_file_path", agent get_output_file_path],
						["bit_rate", agent get_bit_rate],
						["mode", agent get_mode]
					>>)
				end

		Aligned tuple array:

			Getter_functions: EVOLICITY_GETTER_FUNCTION_TABLE
					--
				once
					create Result.make (<<
						["input_file_path",  agent get_input_file_path],
						["output_file_path", agent get_output_file_path],
						["bit_rate",			agent get_bit_rate],
						["mode",					agent get_mode]
					>>)
				end
	]"

end