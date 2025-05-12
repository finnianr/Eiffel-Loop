note
	description: "[
		Object representing table data cell in OpenDocument Flat XML format spreadsheet
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-12 7:50:13 GMT (Monday 12th May 2025)"
	revision: "12"

class
	EL_SPREAD_SHEET_DATA_CELL

inherit
	EL_OPEN_OFFICE

	EVC_EIFFEL_CONTEXT

create
	make_from_context, make, make_empty

feature {NONE} -- Initialization

	make (a_text: ZSTRING)
			-- Initialize from the characters of `s'.
		do
			text := a_text
			make_default
		end

	make_empty
		do
			create text.make_empty
			make_default
		end

	make_from_context (cell_context: EL_XPATH_NODE_CONTEXT)
			-- make cell for single paragraph or multi paragraph cells separated by new line character

			-- Example single:

			--	<table:table-cell table:style-name="ce3" office:value-type="string">
			--		<text:p>St. O. Plunkett N.S.</text:p>
			--	</table:table-cell>

			-- Example multiple:

			--	<table:table-cell table:style-name="ce3" office:value-type="string">
			--		<text:p/>
			--		<text:p>
			--			<text:s/>
			--			St. Helena`s Drive
			--		</text:p>
			--	</table:table-cell>
		local
			paragraph_nodes: EL_XPATH_NODE_CONTEXT_LIST; str: ZSTRING
		do
			cell_context.set_namespace_key (NS_text)
			paragraph_nodes := cell_context.context_list (Xpath_text_paragraph)
			if attached Once_paragraph_list as paragraph_list then
				paragraph_list.wipe_out
				across paragraph_nodes as paragraph loop
					str := paragraph.node.as_full_string
					if str.is_empty then
						str := paragraph.node @ Xpath_text_node
					end
					if str.count > 0 then
						paragraph_list.extend (str)
					end
				end
				make (paragraph_list.joined_lines)
			else
				make_empty
			end
		end

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := text.is_empty
		end

feature -- Access

	count: INTEGER
		do
			Result := text.count
		end

	as_paragraphs: EL_ZSTRING_LIST
		do
			Result := text.lines
		end

	text: ZSTRING

feature {NONE} -- Evolicity reflection

	get_escape_single_quote: ZSTRING
			--
		do
			Result := text
			Result.replace_substring_all ("'", "\'")
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["is_empty",				agent: BOOLEAN_REF do Result := is_empty.to_reference end],
				["escape_single_quote",	agent get_escape_single_quote]
			>>)
		end

feature {NONE} -- Constants

	NS_text: STRING = "text"

	Once_paragraph_list: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

	Xpath_text_node: STRING_32 = "text()"

	Xpath_text_paragraph: STRING_32 = "text:p"

end