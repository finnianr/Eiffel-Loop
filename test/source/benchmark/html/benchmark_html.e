note
	description: "Summary description for {BENCHMARK_HTML}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-25 14:43:23 GMT (Thursday 25th May 2017)"
	revision: "2"

class
	BENCHMARK_HTML

inherit
	EVOLICITY_SERIALIZEABLE
		redefine
			make_default
		end

	EL_MODULE_HTML

	MODULE_HEXAGRAM

create
	make_from_file

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create performance_tables.make (2)
			create memory_tables.make (2)
		end

feature -- Access

	performance_tables: ARRAYED_LIST [PERFORMANCE_BENCHMARK_TABLE]

	memory_tables: ARRAYED_LIST [MEMORY_BENCHMARK_TABLE]

feature {NONE} -- Implemenation

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

	source_links: EL_ZSTRING_LIST
		do
			create Result.make_from_array (<<
				"apps/string/zstring_benchmark_app.e",
				"benchmark/string/string_benchmark.e",
				"benchmark/string/zstring/zstring_benchmark.e",
				"benchmark/string/string_32/string_32_benchmark.e",

				"benchmark/string/mixed_encoding_string_benchmark.e",
				"benchmark/string/zstring/mixed_encoding_zstring_benchmark.e",
				"benchmark/string/string_32/mixed_encoding_string_32_benchmark.e"
			>>)
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["performance_tables", 	agent: like performance_tables do Result := performance_tables end],
				["memory_tables", 	agent: like memory_tables do Result := memory_tables end],
				["data_rows", 	agent data_rows],
				["github_link", 	agent: STRING do Result := github_link end],
				["source_links", agent source_links]
			>>)
		end

feature {NONE} -- Constants

	Github_link: STRING = "https://github.com/finnianr/Eiffel-Loop/blob/master/test/source"

	Template: STRING = "[
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<title>ZSTRING v STRING_32</title>
				<style type="text/css">
					body {
						font-family: Verdana, Helvetica, Arial, Geneva, sans-serif;
						font-size: 20px;
					}
					div#content {
						margin-left: auto;
						margin-right: auto;
						width: 60em;
					}
					h1 { text-align: center; }
					table {
						background-color: white;
						border: 1px solid green;
						width: 35em;
					}
					table caption { text-align: left }
					table#hexagrams {
						width: 60em;
					}
					th, td {
						text-align: left;
						vertical-align: text-top;
						padding: 3px;
					}
					td {
						font-weight: normal;
					}
					tr:nth-child(even) {
						 background-color: Lightblue;
					}
				</style>
			</head>
			<body>
				<div id="content">
				<h1>ZSTRING v STRING_32</h1>
				<h2>Benchmark Source Code on Github</h2>
			#across $source_links as $link loop
				#if $link.cursor_index > 1 then
					<br>
				#end
				<a title="Source on github.com" target="_blank" href="$github_link/$link.item">
					Eiffel-Loop/test/source/$link.item
				</a>
			#end
				<h2>Memory Consumption</h2>
			#across $memory_tables as $table loop
				#evaluate ($table.item.template_name, $table.item)
			#end
				<h2>Runtime Performance</h2>
			#across $performance_tables as $table loop
				#evaluate ($table.item.template_name, $table.item)
			#end
				<h2>I Ching Hexagram Test Strings</h2>
				<table id="hexagrams">
					<caption>Table 5</caption>
					<tr>
						<th width="8%">A</th>
						<th width="9%">B</th>
						<th width="4%">C</th>
						<th>D</th>
					</tr>
				#across $data_rows as $row loop
					<tr>
						$row.item
					</tr>
				#end
				</table>
			</div>
			</body>
		</html>
	]"

end
