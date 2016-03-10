note
	description: "[
		Object representing table data cell in OpenDocument Flat XML format spreadsheet
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 22:12:10 GMT (Monday 22nd July 2013)"
	revision: "4"

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
			create text.make_empty
			make_eiffel_context
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
			paragraph_list: EL_XPATH_NODE_CONTEXT_LIST
			value: EL_ASTRING
		do
			make_empty

			cell_context.set_namespace (NS_text)
			paragraph_list := cell_context.context_list (Xpath_text_paragraph)
			from paragraph_list.start until paragraph_list.after loop
				if paragraph_list.index > 1 then
					text.append_character ('%N')
				end
				value := paragraph_list.context.normalized_string_value
				if value.is_empty then
					value := paragraph_list.context.string_at_xpath (Xpath_text_node)
				end
				text.append (value)
				paragraph_list.forth
			end
			text.left_adjust; text.right_adjust
		end

	make (a_text: EL_ASTRING)
			-- Initialize from the characters of `s'.
		do
			text := a_text
			make_eiffel_context
		end

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := text.is_empty
		end

feature -- Access

	text: EL_ASTRING

	count: INTEGER
		do
			Result := text.count
		end

feature {NONE} -- Evolicity reflection

	get_escape_single_quote: EL_ASTRING
			--
		do
			Result := text.twin
			Result.replace_substring_all ("'", "\'")
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
