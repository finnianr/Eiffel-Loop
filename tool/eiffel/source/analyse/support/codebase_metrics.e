note
	description: "Accumulate statistics for ${EIFFEL_SOURCE_ANALYZER} across many files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-11 11:28:40 GMT (Tuesday 11th June 2024)"
	revision: "6"

class
	CODEBASE_METRICS

inherit
	EL_REFLECTIVE
		rename
			field_included as is_expanded_field,
			foreign_naming as eiffel_naming
		end

	EIFFEL_SOURCE_METRICS

	EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT
		rename
			make_default as make
		end

	EVOLICITY_REFLECTIVE_XML_CONTEXT

	EL_MODULE_LIO

create
	make

feature -- Access

	average_keyword_plus_identifier_count: INTEGER
		do
			Result := ((keyword_count + identifier_count) / routine_count).rounded
		end

	byte_count: INTEGER

	class_count: INTEGER

	mega_bytes: DOUBLE
		do
			Result := byte_count / 1000_000
		end

	formatted_mega_bytes: STRING
		do
			Result := Double.formatted (mega_bytes)
		end

	stats_table: EL_HASH_TABLE [INTEGER, STRING]
			--
		do
			create Result.make (<<
				["Class count",										  class_count],
				["Keyword occurrences",								  keyword_count],
				["Identifier occurrences",							  identifier_count],
				["Keyword + identifier count",					  keyword_count + identifier_count],
				["Routine count",										  routine_count],
				["External routine count",							  external_routine_count],
				["Average keywords + identifiers per routine", average_keyword_plus_identifier_count]
			>>)
		end

feature -- Element change

	add_file (source_path: FILE_PATH)
		local
			analyzer: EIFFEL_SOURCE_ANALYZER
		do
			create analyzer.make_from_file (source_path)
			add_metrics (analyzer.metrics)
		end

	add_metrics (a_metrics: SPECIAL [INTEGER])
		require
			has_5_items: a_metrics.count = Metric_count
		do
		-- in alphabetical order
			byte_count := byte_count + a_metrics [0]
			external_routine_count := external_routine_count + a_metrics [1]
			identifier_count := identifier_count + a_metrics [2]
			keyword_count := keyword_count + a_metrics [3]
			routine_count := routine_count + a_metrics [4]
			class_count := class_count + 1
		end

	add_source (source: READABLE_STRING_8; a_encoding: NATURAL)
		local
			analyzer: EIFFEL_SOURCE_ANALYZER
		do
			create analyzer.make (source, a_encoding)
			add_metrics (analyzer.metrics)
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
			lio.put_labeled_substitution ("Percentiles keywords:identifiers", keyword_to_indentifier_ratio)
			lio.put_new_line
		end

feature {NONE} -- Implementation

	get_keyword_plus_identifier_count: INTEGER_REF
		do
			Result := (keyword_count + identifier_count).to_reference
		end

	get_average_keyword_plus_identifier_count: INTEGER_REF
		do
			Result := average_keyword_plus_identifier_count.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["keyword_plus_identifier_count",			agent get_keyword_plus_identifier_count],
				["average_keyword_plus_identifier_count",	agent get_average_keyword_plus_identifier_count],
			-- String values
				["keyword_to_indentifier_ratio",				agent keyword_to_indentifier_ratio],
				["formatted_mega_bytes",						agent formatted_mega_bytes]
			>>)
		end

	keyword_to_indentifier_ratio: STRING
		local
			template: ZSTRING
		do
			template := "%S%% : %S%%"
			Result := template #$ [percentile (keyword_count), percentile (identifier_count)]
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