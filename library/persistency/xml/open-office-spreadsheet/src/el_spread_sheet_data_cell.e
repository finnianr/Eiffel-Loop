note
	description: "[
		Object representing table data cell in OpenDocument Flat XML format spreadsheet
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-25 8:43:44 GMT (Friday 25th February 2022)"
	revision: "7"

class
	EL_SPREAD_SHEET_DATA_CELL

inherit
	EL_OPEN_OFFICE

	EVOLICITY_EIFFEL_CONTEXT

create
	make_from_context, make, make_empty

feature {NONE} -- Initialization

	make_empty
		do
			create paragraphs.make_empty
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
			make_empty

			cell_context.set_namespace_key (NS_text)
			paragraph_nodes := cell_context.context_list (Xpath_text_paragraph)
			paragraphs.grow (paragraph_nodes.count)
			across paragraph_nodes as paragraph loop
				str := paragraph.node.as_full_string
				if str.is_empty then
					str := paragraph.node @ Xpath_text_node
				end
				if not str.is_empty then
					paragraphs.extend (str)
				end
			end
		end

	make (a_text: ZSTRING)
			-- Initialize from the characters of `s'.
		do
			create paragraphs.make_with_lines (a_text)
			make_default
		end

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := paragraphs.is_empty
		end

feature -- Access

	text: ZSTRING
		do
			Result := paragraphs.joined_lines
		end

	paragraphs: EL_ZSTRING_LIST

	count: INTEGER
		do
			Result := paragraphs.joined_character_count
		end

feature {NONE} -- Implementation

	append_paragraph (paragraph_node: EL_XPATH_NODE_CONTEXT)
		do
			paragraphs.extend (paragraph_node.as_full_string)
			if paragraphs.last.is_empty then
				across paragraph_node.context_list (Xpath_text_node) as l_text loop
					paragraphs.last.append (l_text.node.as_full_string)
				end
			end
		end

feature {NONE} -- Evolicity reflection

	get_escape_single_quote: ZSTRING
			--
		do
			Result := text
			Result.replace_substring_general_all ("'", "\'")
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["is_empty", agent: BOOLEAN_REF do Result := is_empty.to_reference end],
				["escape_single_quote", agent get_escape_single_quote]
			>>)
		end

feature {NONE} -- Constants

	Xpath_text_paragraph: STRING_32 = "text:p"

	NS_text: STRING = "text"

	Xpath_text_node: STRING_32 = "text()"

end