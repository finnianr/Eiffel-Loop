note
	description: "Accumulate statistics for ${EIFFEL_SOURCE_ANALYZER} across many files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	CODEBASE_METRICS

inherit
	EIFFEL_SOURCE_ANALYZER
		rename
			make_from_file as parse_file,
			make as parse_source
		end

	EVOLICITY_EIFFEL_CONTEXT
		rename
			make_default as make
		end

	EL_MODULE_LIO

create
	make

feature -- Access

	average_keyword_plus_identifier_count: INTEGER
		do
			Result := ((keyword_count + identifier_count) / routine_count).rounded
		end

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
			previous_byte_count: INTEGER
		do
			block_indent := 0; debug_indent := 0

			previous_byte_count := byte_count
			parse_file (source_path)
			byte_count := byte_count + previous_byte_count
			class_count := class_count + 1
		end

	add_source (source: READABLE_STRING_8; a_encoding: NATURAL)
		local
			previous_byte_count: INTEGER
		do
			block_indent := 0; debug_indent := 0
			previous_byte_count := byte_count
			parse_source (source, a_encoding)
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
				["class_count",									agent: INTEGER_REF do Result := class_count.to_reference end],
				["external_routine_count",						agent: INTEGER_REF do Result := external_routine_count.to_reference end],
				["routine_count",									agent: INTEGER_REF do Result := routine_count.to_reference end],
				["keyword_count",									agent: INTEGER_REF do Result := keyword_count.to_reference end],
				["identifier_count",								agent: INTEGER_REF do Result := identifier_count.to_reference end],
				["keyword_plus_identifier_count",			agent get_keyword_plus_identifier_count],
				["average_keyword_plus_identifier_count",	agent get_average_keyword_plus_identifier_count],
			-- String values
				["keyword_to_indentifier_ratio",				agent keyword_to_indentifier_ratio],
				["mega_bytes",										agent mega_bytes_string]
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