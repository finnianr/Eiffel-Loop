note
	description: "Summary description for {BENCHMARK_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-11 11:15:14 GMT (Friday 11th March 2016)"
	revision: "5"

deferred class
	BENCHMARK_TABLE

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		redefine
			make_default
		end

	BENCHMARK_ROUTINES

	EL_MODULE_HTML

	EL_MODULE_XML

feature {NONE} -- Initialization

	make_pure (encoding_id: INTEGER; a_string_32_benchmark: like string_32_benchmark; a_zstring_benchmark: like zstring_benchmark)
		do
			make (Title_latin #$ [encoding_id], a_string_32_benchmark, a_zstring_benchmark)
		end

	make_mixed (encoding_id: INTEGER; a_string_32_benchmark: like string_32_benchmark; a_zstring_benchmark: like zstring_benchmark)
		do
			make (Title_mixed #$ [encoding_id], a_string_32_benchmark, a_zstring_benchmark)
		end

	make (a_title: like title; a_string_32_benchmark: like string_32_benchmark; a_zstring_benchmark: like zstring_benchmark)
		do
			make_default
			title := a_title; string_32_benchmark := a_string_32_benchmark; zstring_benchmark := a_zstring_benchmark
			set_data_rows
		end

	make_default
		do
			Precursor
			create data_rows.make (19)
			create title.make_empty
		end

feature -- Access

	data_rows: EL_ZSTRING_LIST

	title: ZSTRING

feature {NONE} -- Implementation

	set_data_rows
		deferred
		end

	column_title: STRING
		deferred
		end

	next_table_id: INTEGER_REF
		do
			Table_id.set_item (Table_id.item + 1)
			Result := Table_id.twin
		end

feature {NONE} -- Internal attributes

	string_32_benchmark: STRING_32_BENCHMARK

	zstring_benchmark: ZSTRING_BENCHMARK

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["column_title", 	agent: STRING do Result := column_title end],
				["title", 			agent: ZSTRING do Result := title end],
				["data_rows", 		agent: EL_ZSTRING_LIST do Result := data_rows end],
				["table_id", 		agent next_table_id]
			>>)
		end

feature {NONE} -- Constants

	Html_row: ZSTRING
		once
			create Result.make (100)
		end

	Table_id: INTEGER_REF
		once
			create Result
		end

	Template: STRING =
	"[
		<h3>$title</h3>
		<caption>Table $table_id</caption>
		<table>
			<tr>
				<th width="40%">$column_title</th>
				<th>Input</th>
				<th>ZSTRING</th>
				<th>STRING_32</th>
			</tr>
		#across $data_rows as $row loop
			<tr>
				$row.item
			</tr>
		#end
		</table>
	]"

	Type_benchmark: STRING_BENCHMARK
		require
			never_called: False
		once
		end

	Title_mixed: ZSTRING
		once
			Result := "Mixed Latin-%S and Unicode Encoding"
		end

	Title_latin: ZSTRING
		once
			Result := "Pure Latin-%S Encoding"
		end

end
