note
	description: "[
		Counts the number of occurrences of identifiers and Eiffel keywords that occur
		within the body of a routine, i.e. between the **do** (or **once**) keyword and the corresponding
		**end** (or **ensure**) at the end of the routine.
		
		But it ignores any identifiers and keywords within code blocks defined by the **check** or
		**debug** keyword. Naturally comments, and anything in quoted text is ignored.
		
		In addition it also records the total source byte count (excluding any BOM).
	]"
	tests: "${EIFFEL_SOURCE_COMMAND_TEST_SET}.test_class_analyzer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-11 11:00:00 GMT (Tuesday 11th June 2024)"
	revision: "8"

class
	EIFFEL_SOURCE_ANALYZER

inherit
	EIFFEL_SOURCE_READER

	EIFFEL_SOURCE_METRICS

create
	make, make_from_file

feature -- Contract Support

	block_indent_0_at_routine_start (type: INTEGER_64): BOOLEAN
		do
			Result := type = Type_routine implies block_indent = 0
		end

feature {NONE} -- Events

	on_comment (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_identifier (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
			if debug_indent.to_boolean then
				do_nothing

			elseif block_indent.to_boolean then
				identifier_count := identifier_count + 1
			end
		end

	on_keyword (area: SPECIAL [CHARACTER]; i, count: INTEGER; type: INTEGER_64)
		require else
			block_indent_0_at_routine_start: block_indent_0_at_routine_start (type)
		do
			if debug_indent.to_boolean then
				if type = Type_end_block then
					debug_indent := debug_indent - 1

				elseif type = Type_block then
					block_indent := block_indent + 1
				end

			elseif block_indent.to_boolean then
				if type = Type_end_block then
					block_indent := block_indent - 1

				elseif type = Type_debug then
					debug_indent := debug_indent + 1

				else
					if type = Type_block then
						block_indent := block_indent + 1
					end
					keyword_count := keyword_count + 1
				end

			elseif type = Type_routine then
				block_indent := block_indent + 1
				routine_count := routine_count + 1

			elseif type = Type_external then
				external_routine_count := external_routine_count + 1
			end
		end

	on_manifest_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_numeric_constant (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_quoted_character (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_quoted_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

feature {NONE} -- Internal attributes

	block_indent: INTEGER

	debug_indent: INTEGER
end