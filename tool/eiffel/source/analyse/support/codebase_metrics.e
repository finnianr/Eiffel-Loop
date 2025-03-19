note
	description: "Accumulate statistics for ${EIFFEL_SOURCE_ANALYZER} across many files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:04:06 GMT (Tuesday 18th March 2025)"
	revision: "12"

class
	CODEBASE_METRICS

inherit
	EL_REFLECTIVE
		rename
			field_included as is_expanded_field,
			foreign_naming as eiffel_naming
		end

	EIFFEL_SOURCE_METRICS

	EVC_REFLECTIVE_EIFFEL_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

	EVC_REFLECTIVE_XML_CONTEXT

	EL_MODULE_LIO

	EL_DOUBLE_MATH
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create rountine_count_interval_list.make (5)
			if attached rountine_count_interval_list as list then
				list.extend (0, 0)
				list.extend (1, 1)
				list.extend (2, 10)
				list.extend (11, 20)
				list.extend (21, 40)
				list.extend (41, 60)
				list.extend (61, 80)
				list.extend (81, 100)
				list.extend (101, 150)
				list.extend (151, byte_count.Max_value)
				create routine_class_count.make_filled (0, 1, list.count)
			end
		end

feature -- Access

	average_keyword_plus_identifier_count: INTEGER
		do
			Result := ((keyword_count + identifier_count) / routine_count).rounded
		end

	byte_count: INTEGER

	class_count: INTEGER

	external_class_count: INTEGER

	formatted_mega_bytes: STRING
		do
			Result := Double.formatted (mega_bytes)
		end

	mega_bytes: DOUBLE
		do
			Result := byte_count / 1000_000
		end

	routine_class_count: ARRAY [INTEGER]

	stats_table: EL_HASH_TABLE [INTEGER, STRING]
			--
		do
			create Result.make_assignments (<<
				["Class count",										  class_count],
				["Keyword count",										  keyword_count],
				["Identifier count",									  identifier_count],
				["Combined count",									  keyword_count + identifier_count],
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
		-- add metrics from array result of `{EIFFEL_SOURCE_METRICS}.metrics'
		require
			has_5_items: a_metrics.count = Metric_count
		local
			found: BOOLEAN; class_routine_count, class_external_routine_count: INTEGER
		do
		-- in alphabetical order
			byte_count := byte_count + a_metrics [0]
			class_external_routine_count := a_metrics [1]
			identifier_count := identifier_count + a_metrics [2]
			keyword_count := keyword_count + a_metrics [3]
			class_routine_count := a_metrics [4]

			external_routine_count := external_routine_count + class_external_routine_count
			routine_count := routine_count + class_routine_count
			class_count := class_count + 1

			if class_routine_count = 0 and class_external_routine_count > 0 then
				external_class_count := external_class_count + 1

			elseif attached rountine_count_interval_list as list then
				from list.start until list.after or found loop
					if list.item_has (class_routine_count) then
						routine_class_count [list.index] := routine_class_count [list.index] + 1
						found := True
					else
						list.forth
					end
				end
			end
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
		local
			semicolon_lines: ARRAY [INTEGER]
		do
			semicolon_lines := << 1, 2, 3, 5 >>
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
				if semicolon_lines.has (table.cursor_index) then
					lio.put_string ("; ")
				else
					lio.put_new_line
				end
			end
			lio.put_labeled_substitution ("Percentiles keywords:identifiers", keyword_to_indentifier_ratio)
			lio.put_new_line_x2
			lio.put_line ("Routine count class distribution")
			lio.put_new_line
			across routine_count_band_table as table loop
				lio.put_integer_field (table.key, table.item); lio.put_character ('%%')
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	interval_band_name (lower, upper: INTEGER): STRING
		local
			template: ZSTRING
		do
			if lower = upper then
				inspect lower
					when 0 then
						Result := "Zero" + Routines_suffix
					when 1 then
						Result := "One" + Routines_suffix
						Result.remove_tail (1)
				else
				end

			elseif upper = byte_count.Max_value then
				Result := "More than " + lower.out + Routines_suffix
			else
				template := "%S to %S" + Routines_suffix
				Result := template #$ [lower, upper]
			end
		end

	keyword_to_indentifier_ratio: STRING
		local
			template: ZSTRING; keyword_percent, identifier_percent: INTEGER
		do
			template := "%S%% : %S%%"
			keyword_percent := percent (keyword_count, keyword_plus_identifier_count.item)
			identifier_percent := percent (identifier_count, keyword_plus_identifier_count.item)
			Result := template #$ [keyword_percent, identifier_percent]
		end

	routine_count_band_table: HASH_TABLE [INTEGER_REF, STRING]
		local
			class_percentile: INTEGER
		do
			create Result.make (routine_class_count.count)
			if attached rountine_count_interval_list as list then
				from list.start until list.after loop
					class_percentile := percent (routine_class_count [list.index], class_count)
					if class_percentile.to_boolean then
						Result.extend (class_percentile.to_reference, interval_band_name (list.item_lower, list.item_upper))
					end
					list.forth
				end
			end
			if external_class_count > 0 then
				class_percentile := percent (external_class_count, class_count)
				Result.extend (class_percentile.to_reference, "External C/C++" + Routines_suffix)
			end
		end

feature {NONE} -- Evolicity fields

	average_keyword_plus_identifier_ref_count: INTEGER_REF
		do
			Result := average_keyword_plus_identifier_count.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["average_keyword_plus_identifier_count",	agent average_keyword_plus_identifier_ref_count],
				["keyword_plus_identifier_count",			agent keyword_plus_identifier_count],

			-- String values
				["keyword_to_indentifier_ratio",				agent keyword_to_indentifier_ratio],
				["formatted_mega_bytes",						agent formatted_mega_bytes],
				["routine_count_band_table",					agent routine_count_band_table]
			>>)
		end

	keyword_plus_identifier_count: INTEGER_REF
		do
			Result := (keyword_count + identifier_count).to_reference
		end

feature {NONE} -- Internal attributes

	rountine_count_interval_list: EL_SEQUENTIAL_INTERVALS

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (6, 2)
			Result.no_justify
		end

	Routines_suffix: STRING = " routines"

end