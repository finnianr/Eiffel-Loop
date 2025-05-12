note
	description: "[
		Test classes from library cluster `markup-docs.ecf#open_office'

		* ${EL_SPREAD_SHEET}
		* ${EL_SPREAD_SHEET_TABLE}
		* ${EL_SPREAD_SHEET_ROW}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-12 8:09:55 GMT (Monday 12th May 2025)"
	revision: "36"

class
	OPEN_OFFICE_TEST_SET

inherit
	READ_DATA_EQA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["open_office_spreadsheet", agent test_open_office_spreadsheet]
			>>)
		end

feature -- Tests

	test_open_office_spreadsheet
		note
			testing: "[
				covers/{EL_SPREAD_SHEET}.make,
				covers/{EL_XML_DOC_CONTEXT}.new_namespace_table,
				covers/{EL_XPATH_NODE_CONTEXT}.do_query,
				covers/{EL_XPATH_NODE_CONTEXT}.context_list,
				covers/{EL_XPATH_NODE_CONTEXT}.find_node,
				covers/{EL_XPATH_NODE_CONTEXT}.query,
				covers/{EL_ROUTINE_LOG}.put_field_list,
				covers/{EL_READABLE_STRING_GENERAL_ROUTINES_I}.word_count
			]"
		local
			xdoc: EL_XML_DOC_CONTEXT; file_path: FILE_PATH
		do
			file_path := Data_dir.xml + "Jobs-spreadsheet.fods"
			create xdoc.make_from_file (file_path)
			across Namespace_list.split ('%N') as name loop
				assert ("has namespace " + name.item, xdoc.namespace_table.has (name.item))
			end
			do_test ("print_spreadsheet", 1037109490, agent print_spreadsheet, [xdoc, file_path.base_name])
		end

feature {NONE} -- Implementation

	print_spreadsheet (xdoc: EL_XML_DOC_CONTEXT; name: ZSTRING)
		local
			spread_sheet: EL_SPREAD_SHEET; s: EL_ZSTRING_ROUTINES
		do
			create spread_sheet.make_with_xdoc (xdoc, name, "")
			across spread_sheet as table loop
				across table.item as row loop
					lio.put_field_list (100, <<
						["Row", row.cursor_index],
						["Type", row.item.cell ("Type").text],
						["Title", row.item.cell ("Title").text]
					>>)
					lio.put_new_line
					if attached row.item.cell (Description).text as text then
						lio.put_integer_field ("Word count", s.word_count (text, False))
						lio.put_new_line
					end
				end
			end
		end

feature {NONE} -- Constants

	Description: STRING = "Description"

	Namespace_list: STRING = "[
		office
		style
		text
		table
		draw
		fo
		xlink
		dc
		meta
		number
		presentation
		svg
		chart
		dr3d
		math
		form
		script
		config
		ooo
		ooow
		oooc
		dom
		xforms
		xsd
		xsi
		rpt
		of
		xhtml
		grddl
		tableooo
		calcext
		field
		formx
		css3t
	]"

end