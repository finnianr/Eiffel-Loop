note
	description: "Accumulate statistics for [$source EIFFEL_SOURCE_ANALYZER] across many files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-17 10:03:31 GMT (Sunday 17th September 2023)"
	revision: "1"

class
	CODEBASE_METRICS

inherit
	EIFFEL_SOURCE_ANALYZER
		rename
			make as parse
		end

	EVOLICITY_EIFFEL_CONTEXT
		rename
			make_default as make
		end

	EL_MODULE_LIO

create
	make
	
feature -- Access

	class_count: INTEGER

	mega_bytes: DOUBLE
		do
			Result := byte_count / 1000_000
		end

	mega_bytes_string: STRING
		do
			Result := Double.formatted (mega_bytes)
		end

	stats_table: EL_HASH_TABLE [INTEGER, STRING]
			--
		do
			create Result.make (<<
				["Class count",						class_count],
				["Keyword occurrences",				keyword_count],
				["Identifier occurrences",			identifier_count],
				["Keyword + identifier count",	keyword_count + identifier_count],
				["Routine count",						routine_count],
				["Keyword + identifier average",	((keyword_count + identifier_count) / routine_count).rounded]
			>>)
		end

feature -- Element change

	add (source_path: FILE_PATH)
		local
			previous_byte_count: INTEGER
		do
			block_indent := 0; debug_indent := 0

			previous_byte_count := byte_count
			parse (source_path)
			byte_count := byte_count + previous_byte_count
			class_count := class_count + 1
		end

feature -- Basic operations

	display
		do
			across stats_table as table loop
				if table.cursor_index = 2 then
					if byte_count < 100000 then
						lio.put_integer_field ("Total bytes (excluding BOM)", byte_count)
					else
						lio.put_labeled_string ("Total mega bytes", Double.formatted (mega_bytes))
					end
					lio.put_new_line_x2
				end
				lio.put_integer_field (table.key, table.item)
				lio.put_new_line
			end
			lio.put_labeled_substitution (
				"Percentiles keywords:identifiers", "%S%%:%S%%", [percentile (keyword_count), percentile (identifier_count)]
			)
			lio.put_new_line
		end

feature {NONE} -- Implementation

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_count",				agent: INTEGER_REF do Result := class_count.to_reference end],
				["external_routine_count",	agent: INTEGER_REF do Result := external_routine_count.to_reference end],
				["routine_count",				agent: INTEGER_REF do Result := routine_count.to_reference end],
				["keyword_count",				agent: INTEGER_REF do Result := keyword_count.to_reference end],
				["routine_count",				agent: INTEGER_REF do Result := routine_count.to_reference end],
				["identifier_count",			agent: INTEGER_REF do Result := identifier_count.to_reference end],
				["mega_bytes",					agent mega_bytes_string]
			>>)
		end

	percentile (occurrence_count: INTEGER): INTEGER
		do
			Result := ((occurrence_count / (keyword_count + identifier_count)) * 100).rounded
		end

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (6, 2)
			Result.no_justify
		end
end