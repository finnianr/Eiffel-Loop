note
	description: "Benchmark table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:32 GMT (Tuesday 18th March 2025)"
	revision: "20"

deferred class
	BENCHMARK_TABLE

inherit
	EVC_SERIALIZEABLE_AS_XML
		redefine
			make_default
		end

	EL_BENCHMARK_ROUTINES

	EL_MODULE_HTML; EL_MODULE_XML

feature {NONE} -- Initialization

	make (a_benchmark_z: like benchmark_z; a_benchmark_32: like benchmark_32)
		do
			make_default
			title := a_benchmark_z.title
			benchmark_z := a_benchmark_z; benchmark_32 := a_benchmark_32
			trial_duration_ms := benchmark_z.trial_duration_ms
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

	trial_duration_ms: INTEGER

feature -- Status query

	is_memory: BOOLEAN
		deferred
		end

feature {NONE} -- Implementation

	append_to_row (row: like Html_row; index: INTEGER)
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

	relative_percentage_at_index (index: INTEGER): INTEGER
		local
			a, b: DOUBLE
		do
			a := test_result (benchmark_z, index)
			b := test_result (benchmark_32, index)
			Result := relative_percentage (a, b)
		end

	set_data_rows
		do
			across sorted_indices as index loop
				Html_row.wipe_out
				append_to_row (Html_row, index.item)
				data_rows.extend (Html_row.twin)
			end
		end

	sorted_indices: EL_ARRAYED_LIST [INTEGER]
		do
			create Result.make_from (1 |..| test_count)
			Result.order_by (agent relative_percentage_at_index, is_memory)
		end

	test_count: INTEGER
		deferred
		end

	test_result (a_benchmark: STRING_BENCHMARK; index: INTEGER): DOUBLE
		deferred
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["column_title", agent: STRING do Result := column_title end],
				["title",		  agent: ZSTRING do Result := title end],
				["data_rows",	  agent: EL_ZSTRING_LIST do Result := data_rows end],
				["table_id",	  agent next_table_id]
			>>)
		end

feature {NONE} -- Internal attributes

	benchmark_32: STRING_32_BENCHMARK

	benchmark_z: ZSTRING_BENCHMARK

feature {NONE} -- Constants

	Html_row: ZSTRING
		once
			create Result.make (100)
		end

	Table_id: INTEGER_REF
		once
			create Result
		end

	Template: STRING = "[
		<h3>$title</h3>
		<caption>Table $table_id (In ascending order of relative STRING_32 performance)</caption>
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

end