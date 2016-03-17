note
	description: "[
		Object representing OpenDocument Flat XML spreadsheet as tables of rows of data strings
		
		xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
		office:mimetype="application/vnd.oasis.opendocument.spreadsheet"
		office:version="1.2"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 23:25:04 GMT (Friday 18th December 2015)"
	revision: "7"

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

	EL_MODULE_LOG
		undefine
			copy, is_equal
		end

create
	make, make_with_tables

feature {NONE} -- Initaliazation

	make (file_name: EL_FILE_PATH)
			--
		do
			make_with_tables (file_name, << Wildcard_all >>)
		end

	make_with_tables (file_name: EL_FILE_PATH; table_names: ARRAY [ZSTRING])
			-- make with selected table names
		require
			valid_file_type: is_valid_file_type (file_name)
		local
			xpath, cell_range_address, name: ZSTRING
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
			table_nodes: EL_XPATH_NODE_CONTEXT_LIST
			defined_ranges: EL_ZSTRING_HASH_TABLE [ZSTRING]
			spreadsheet_ctx, document_ctx: EL_XPATH_NODE_CONTEXT
		do
			log.enter ("make_with_tables")
			create tables.make_equal (5)
			create defined_ranges.make_equal (11)
			log.put_line ("Parsing XML")
			create root_node.make_from_file (file_name)
			log.put_line ("Building spreadsheet")

			root_node.set_namespace ("office")

			root_node.find_node ("/office:document")
			if root_node.node_found then
				document_ctx := root_node.found_node
				document_ctx.set_namespace ("office")
				office_version := document_ctx.real_at_xpath ("@office:version")
				mimetype := document_ctx.string_at_xpath ("@office:mimetype")
				check
					valid_mimetype: mimetype ~ Open_document_spreadsheet
					valid_office_version: office_version >= 1.1
				end
				document_ctx.find_node ("office:body/office:spreadsheet")
				if document_ctx.node_found then
					spreadsheet_ctx := document_ctx.found_node
					spreadsheet_ctx.set_namespace ("table")
					across spreadsheet_ctx.context_list ("table:named-expressions/table:named-range") as named_range loop
						cell_range_address := named_range.node.attributes ["table:cell-range-address"]
						cell_range_address.prune_all ('$')
						name := named_range.node.attributes ["table:name"]
						defined_ranges [cell_range_address] := name
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
			log.exit
		end

feature -- Access

	office_version: REAL

	mimetype: ZSTRING

	table (a_name: ZSTRING): EL_SPREAD_SHEET_TABLE
		do
			Result := tables [a_name]
		end

feature -- Contract support

	is_valid_file_type (file_name: EL_FILE_PATH): BOOLEAN
		local
			xml: EL_XML_NAMESPACES
		do
			create xml.make_from_file (file_name)
			xml.namespace_urls.search ("office")
			if xml.namespace_urls.found then
				Result := xml.namespace_urls.found_item ~ Office_namespace_url
			end
		end

feature {NONE} -- Implementation

	selected_tables_xpath (table_names: ARRAY [ZSTRING]): ZSTRING
		local
			name_predicate: ZSTRING
			i: INTEGER
		do
			create name_predicate.make_empty
			if not (table_names.count = 1 and then table_names.item (1) ~ Wildcard_all) then
				name_predicate.append_character ('[')
				from i := 1 until  i > table_names.count loop
					if i > 1 then
						name_predicate.append_string (Or_operator)
					end
					name_predicate.append_string_general ("@table:name='")
					name_predicate.append (table_names [i])
					name_predicate.append_character ('%'')
					i := i + 1
				end
				name_predicate.append_character (']')
			end
			Result := "table:table" + name_predicate
		end

	tables: EL_ZSTRING_HASH_TABLE [EL_SPREAD_SHEET_TABLE]

feature {NONE} -- Constants

	Wildcard_all: ZSTRING
		once
			Result := "*"
		end

	Or_operator: ZSTRING
		once
			Result := " or "
		end
end
