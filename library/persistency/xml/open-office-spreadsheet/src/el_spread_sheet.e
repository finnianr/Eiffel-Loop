note
	description: "[
		Object representing [http://www.datypic.com/sc/odf/e-office_spreadsheet.html OpenDocument Flat XML spreadsheets]
		as tables of rows of data strings.
		
		**XML namespace**
			xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
			office:mimetype="application/vnd.oasis.opendocument.spreadsheet"
			office:version="1.2"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 14:43:00 GMT (Thursday 3rd February 2022)"
	revision: "13"

class
	EL_SPREAD_SHEET

inherit
	ARRAYED_LIST [EL_SPREAD_SHEET_TABLE]
		rename
			make as make_array,
			item as table_item,
			first as first_table,
			last as last_table
		end

	EL_OPEN_OFFICE
		undefine
			is_equal, out, copy
		end

	EL_NAMEABLE [ZSTRING]
		undefine
			is_equal, out, copy
		end

	EL_MODULE_LIO

create
	make, make_with_root_node

feature {NONE} -- Initaliazation

	make (file_path: FILE_PATH)
			--
		require
			valid_file_type: is_valid_file_type (file_path)
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			create root_node.make_from_file (file_path)
			make_with_root_node (root_node, file_path.base_sans_extension, Empty_list)
		end

	make_with_root_node (root_node: EL_XPATH_ROOT_NODE_CONTEXT; a_name: ZSTRING; table_names: EL_ZSTRING_LIST)
		-- make with selected table names
		local
			xpath, cell_range_address, l_name: ZSTRING
			table_nodes: EL_XPATH_NODE_CONTEXT_LIST
			defined_ranges: EL_ZSTRING_HASH_TABLE [ZSTRING]
		do
			name := a_name
			create tables.make_equal (5)
			create defined_ranges.make_equal (11)
			if is_lio_enabled then
				lio.put_labeled_substitution (generator, "make (%"%S%")", [a_name])
				lio.put_new_line
			end
			root_node.set_namespace_key ("office")

			if attached root_node.find_node ("/office:document") as document_ctx then
				document_ctx.set_namespace_key ("office")
				office_version := document_ctx.real_at_xpath ("@office:version")
				mimetype := document_ctx.string_at_xpath ("@office:mimetype")
				check
					valid_mimetype: mimetype ~ Open_document_spreadsheet
					valid_office_version: office_version >= 1.1
				end
				if attached document_ctx.find_node ("office:body/office:spreadsheet") as spreadsheet_ctx then
					spreadsheet_ctx.set_namespace_key ("table")
					across spreadsheet_ctx.context_list ("table:named-expressions/table:named-range") as named_range loop
						cell_range_address := named_range.node.attributes ["table:cell-range-address"]
						cell_range_address.prune_all ('$')
						l_name := named_range.node.attributes ["table:name"]
						defined_ranges [cell_range_address] := l_name
					end
					xpath := selected_tables_xpath (table_names)
					table_nodes := spreadsheet_ctx.context_list (xpath.to_unicode)
					make_array (table_nodes.count)

					across table_nodes as table_context loop
						extend (create {EL_SPREAD_SHEET_TABLE}.make (table_context.node, defined_ranges))
						tables.put (last_table, last_table.name)
					end
				end
			end
			lio.put_new_line
		end

feature -- Access

	mimetype: ZSTRING

	name: ZSTRING

	office_version: REAL

	table (a_name: ZSTRING): EL_SPREAD_SHEET_TABLE
		do
			Result := tables [a_name]
		end

feature -- Contract support

	is_valid_file_type (file_path: FILE_PATH): BOOLEAN
		local
			ns_table: EL_XML_NAME_SPACE_TABLE
		do
			create ns_table.make_from_file (file_path)
			if ns_table.has_key ("office") then
				Result := ns_table.found_item ~ Office_namespace_url
			end
		end

feature {NONE} -- Implementation

	selected_tables_xpath (table_names: EL_ZSTRING_LIST): ZSTRING
		do
			Result := "table:table"
			if table_names.count > 0 then
				Result.append_character ('[')
				across table_names as list loop
					if not list.is_first then
						Result.append_string (Or_operator)
					end
					Result.append (Table_name_test #$ [list.item])
				end
				Result.append_character (']')
			end
		end

feature {NONE} -- Internal attributes

	tables: EL_ZSTRING_HASH_TABLE [EL_SPREAD_SHEET_TABLE]

feature {NONE} -- Constants

	Or_operator: ZSTRING
		once
			Result := " or "
		end

	Table_name_test: ZSTRING
		once
			Result := "@table:name='%S'"
		end

	Empty_list: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

end