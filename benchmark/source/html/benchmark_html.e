note
	description: "Benchmark html"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-19 15:42:56 GMT (Sunday 19th February 2023)"
	revision: "14"

class
	BENCHMARK_HTML

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			make_from_template_and_output as make
		redefine
			make_default
		end

	EL_MODULE_HTML

	EL_MODULE_OS

	SHARED_HEXAGRAM_STRINGS

	EL_SHARED_FIND_FILE_FILTER_FACTORY

	EL_SHARED_ZSTRING_CODEC

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create performance_tables.make (2)
			create memory_tables.make (2)
		end

feature -- Access

	memory_tables: ARRAYED_LIST [MEMORY_BENCHMARK_TABLE]

	performance_tables: ARRAYED_LIST [PERFORMANCE_BENCHMARK_TABLE]

feature -- Element change

	extend (benchmark_z: ZSTRING_BENCHMARK; benchmark_32: STRING_32_BENCHMARK)
		do
			performance_tables.extend (create {PERFORMANCE_BENCHMARK_TABLE}.make (benchmark_z, benchmark_32))
			memory_tables.extend (create {MEMORY_BENCHMARK_TABLE}.make (benchmark_z, benchmark_32))
		end

feature {NONE} -- Implemenation

	base_name_has_words (a_path: ZSTRING; words: ARRAY [ZSTRING]): BOOLEAN
		local
			path: FILE_PATH
		do
			path := a_path
			Result := across words as word all path.base.has_substring (word.item) end
		end

	data_rows: EL_ZSTRING_LIST
		local
			html_row, data_string: ZSTRING
			string_count: STRING
		do
			create Result.make (64)
			create html_row.make (100)
			across Hexagram.string_arrays as array loop
				html_row.wipe_out
				across array.item as l_string loop
					create data_string.make_from_general (l_string.item)
					html_row.append (Html.table_data (data_string))
				end
				Result.extend (html_row.twin)
			end
		end

	source_links_table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		local
			name: ZSTRING; has_string_or_benchmark: like Filter.predicate
		do
			create Result.make_equal (11)
			has_string_or_benchmark := Filter.predicate (agent base_name_has_words (?, << "string", "benchmark" >>))
			across OS.filtered_file_list ("source/benchmark", "*.e", has_string_or_benchmark) as path loop
				name := path.item.base.as_upper
				name.remove_tail (2)
				Result [name] := path.item.with_new_extension ("html")
			end
		end

feature {NONE} -- Evolicity fields

	get_trial_duration_ms: INTEGER_REF
		do
			Result := performance_tables.first.trial_duration_ms.to_reference
		end

	get_date: STRING
		local
			date: EL_DATE
		do
			create date.make_now
			Result := date.formatted_out ("dd Mmm yyy")
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["date", 					agent get_date],
				["data_rows",				agent data_rows],
				["encoding",				agent: STRING do Result := Codec.name end],
				["github_link",			agent: STRING do Result := github_link end],
				["memory_tables", 		agent: like memory_tables do Result := memory_tables end],
				["performance_tables",	agent: like performance_tables do Result := performance_tables end],
				["source_links",			agent source_links_table],
				["trial_duration_ms",	agent get_trial_duration_ms]
			>>)
		end

feature {NONE} -- Constants

	Github_link: STRING = "https://github.com/finnianr/Eiffel-Loop/blob/master/test/source"

	Template: STRING = ""

end