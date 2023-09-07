note
	description: "[
		Test classes from library cluster `markup-docs.ecf#open_office'

		* [$source EL_SPREAD_SHEET]
		* [$source EL_SPREAD_SHEET_TABLE]
		* [$source EL_SPREAD_SHEET_ROW]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 12:13:32 GMT (Thursday 7th September 2023)"
	revision: "32"

class
	OPEN_OFFICE_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
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
			testing: "covers/{EL_SPREAD_SHEET}.make", "covers/{EL_XPATH_NODE_CONTEXT}.do_query",
						"covers/{EL_XML_DOC_CONTEXT}.new_namespace_table",
						"covers/{EL_XPATH_NODE_CONTEXT}.context_list, covers/{EL_XPATH_NODE_CONTEXT}.find_node",
						"covers/{EL_XPATH_NODE_CONTEXT}.query",
						"covers/{EL_ROUTINE_LOG}.put_field_list"
		local
			xdoc: EL_XML_DOC_CONTEXT; file_path: FILE_PATH
		do
			file_path := "XML/Jobs-spreadsheet.fods"
			create xdoc.make_from_file (file_path)
			across Namespace_list.split ('%N') as name loop
				assert ("has namespace " + name.item, xdoc.namespace_table.has (name.item))
			end
			do_test ("print_spreadsheet", 70947134, agent print_spreadsheet, [xdoc, file_path.base_name])
		end

feature {NONE} -- Implementation

	print_spreadsheet (xdoc: EL_XML_DOC_CONTEXT; name: ZSTRING)
		local
			spread_sheet: EL_SPREAD_SHEET
		do
			create spread_sheet.make_with_xdoc (xdoc, name, "")
			across spread_sheet as table loop
				across table.item as row loop
					lio.put_field_list (100, <<
						["Row", row.cursor_index],
						["Type", row.item.cell ("Type").text],
						["Paragraphs", row.item.cell ("Description").paragraphs.count],
						["Title", row.item.cell ("Title").text]
					>>)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Constants

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