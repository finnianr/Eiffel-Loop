note
	description: "Summary description for {BENCHMARK_HTML}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-03 13:24:23 GMT (Thursday 3rd March 2016)"
	revision: "5"

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
					create data_string.make_from_unicode (l_string.item)
					html_row.append (Html.table_data (data_string))
				end
				Result.extend (html_row.twin)
			end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["performance_tables", 	agent: like performance_tables do Result := performance_tables end],
				["memory_tables", 	agent: like memory_tables do Result := memory_tables end],
				["data_rows", 	agent data_rows]
			>>)
		end

feature {NONE} -- Constants

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
