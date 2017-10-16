note
	description: "Summary description for {BENCHMARK_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	BENCHMARK_TABLE

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		redefine
			make_default
		end

	EL_BENCHMARK_ROUTINES

	EL_MODULE_HTML

	EL_MODULE_XML

feature {NONE} -- Initialization

	make (encoding_id: INTEGER; a_benchmark: like benchmark)
		require
			valid_zstring_benchmark: attached {ZSTRING_BENCHMARK} a_benchmark.zstring
			valid_string_32_benchmark: attached {STRING_32_BENCHMARK} a_benchmark.string_32
		do
			make_default
			if attached {MIXED_ENCODING_ZSTRING_BENCHMARK} a_benchmark.zstring then
				title := Title_mixed #$ [encoding_id]
			else
				title := Title_latin #$ [encoding_id]
			end
			benchmark := a_benchmark
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

	benchmark: TUPLE [zstring, string_32: STRING_BENCHMARK]

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

feature {NONE} -- Type definition

	Type_benchmark: STRING_BENCHMARK
		require
			never_called: False
		once
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

	Title_mixed: ZSTRING
		once
			Result := "Mixed Latin-%S and Unicode Encoding"
		end

	Title_latin: ZSTRING
		once
			Result := "Pure Latin-%S Encoding"
		end

end