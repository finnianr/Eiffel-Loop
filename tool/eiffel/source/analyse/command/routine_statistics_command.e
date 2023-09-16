note
	description: "[
		Analyzes each class in a specified source manifest or source directory
		using the class [$source EIFFEL_SOURCE_ANALYZER] and displays totaled metrics
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-16 12:39:13 GMT (Saturday 16th September 2023)"
	revision: "1"

class
	ROUTINE_STATISTICS_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			make_default, execute
		end

	EVOLICITY_EIFFEL_CONTEXT
		redefine
			make_default
		end

	EL_MODULE_FILE_SYSTEM

create
	make, make_default, default_create

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			Precursor {SOURCE_MANIFEST_COMMAND}
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
		end

feature -- Access

	Description: STRING = "[
		Count occurrences of identifiers and Eiffel keywords within routine bodies
	]"

	byte_count: INTEGER
		-- source byte count excluding BOM

	class_count: INTEGER

	identifier_count: INTEGER

	keyword_count: INTEGER

	mega_bytes: DOUBLE
		do
			Result := byte_count / 1000_000
		end

	routine_count: INTEGER

feature -- Basic operations

	add_class_stats (analyzer: EIFFEL_SOURCE_ANALYZER)
		do
			class_count := class_count + 1
			byte_count := byte_count + analyzer.byte_count
			routine_count := routine_count + analyzer.routine_count
			keyword_count := keyword_count + analyzer.keyword_count
			identifier_count := identifier_count + analyzer.identifier_count
		end

	do_with_file (source_path: FILE_PATH)
		do
			add_class_stats (create {EIFFEL_SOURCE_ANALYZER}.make (source_path))
		end

	execute
		do
			Precursor
			lio.put_new_line
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
			lio.put_new_line_x2
		end

feature {NONE} -- Implementation

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_count",		agent: INTEGER_REF do Result := class_count.to_reference end],
				["keyword_count",		agent: INTEGER_REF do Result := keyword_count.to_reference end],
				["routine_count",		agent: INTEGER_REF do Result := routine_count.to_reference end],
				["identifier_count",	agent: INTEGER_REF do Result := identifier_count.to_reference end],
				["mega_bytes",			agent: STRING do Result := Double.formatted (mega_bytes) end]
			>>)
		end

	percentile (occurrence_count: INTEGER): INTEGER
		do
			Result := ((occurrence_count / (keyword_count + identifier_count)) * 100).rounded
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

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (6, 2)
			Result.no_justify
		end

end