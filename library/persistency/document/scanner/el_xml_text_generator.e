note
	description: "[
		Generate XML document from node scan source to `output'.
		If `output' conforms to ${EL_OUTPUT_MEDIUM} then the output encoding is the one set in the
		medium, otherwise the output encoding is the same as `event_source.encoding'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 16:56:44 GMT (Tuesday 5th November 2024)"
	revision: "36"

class
	EL_XML_TEXT_GENERATOR

inherit
	EL_DOCUMENT_NODE_SCANNER
		export
			{NONE} all
		redefine
			make_default, on_meta_data
		end

	EL_SET [CHARACTER_8]
		rename
			has as has_reserved
		end

	EL_MODULE_LIO

	EL_CHARACTER_8_CONSTANTS; EL_STRING_8_CONSTANTS; XML_STRING_8_CONSTANTS

	EL_SHARED_FORMAT_FACTORY; EL_SHARED_STRING_8_CURSOR

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			create output_stack.make (10)
			create buffer; create buffer_8
			Precursor
		end

feature -- Basic operations

	convert_lines (lines: ITERABLE [STRING]; a_output: like output)
			--
		require
			valid_output: a_output.is_open_write and a_output.is_writable
		do
			set_output (a_output)
			do_scan (agent	scan_from_lines (lines))
		ensure
			stack_empty: output_stack.is_empty
		end

	convert_stream (a_input, a_output: like output)
			--
		require
			valid_input: a_input.is_open_read and a_input.is_readable
			valid_output: a_output.is_open_write and a_output.is_writable
		do
			set_output (a_output)
			do_scan (agent	scan_from_stream (a_input))
		ensure
			stack_empty: output_stack.is_empty
		end

	convert_text (text: STRING; a_output: like output)
			--
		require
			valid_output: a_output.is_open_write and a_output.is_writable
		do
			set_output (a_output)
			do_scan (agent	scan (text))
		ensure
			stack_empty: output_stack.is_empty
		end

feature {NONE} -- Parsing events

	on_comment
			--
		do
			put_last_tag (True)
			output.put_string (tab * output_stack.count)
			output.put_string (Bracket.left_comment)
			if attached last_node as node then
				if node.has (New_line_character) then
					output.put_new_line
					put_content_lines (node, True)
					output.put_string (tab * output_stack.count)
				else
					put_single_line (node)
				end
			end
			output.put_string (Bracket.right_comment)
			output.put_new_line
			last_state := State_comment
		end

	on_content (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			put_last_tag (False)
			put_content (node)
		end

	on_end_document
			--
		do
		end

	on_end_tag
			--
		local
			last_tag_output, tag_output: EL_STRING_8_LIST
		do
			last_tag_output := output_stack.item
			if last_tag_output.last = Bracket.slash_right then
				tag_output := last_tag_output
			else
				create tag_output.make (4)
				if last_state /= State_content then
					tag_output.extend (last_tag_output [1]) 		-- 1. Tabs
				end
				tag_output.extend (Bracket.left_slash)				-- 2.
				tag_output.extend (last_tag_output [3]) 			-- 3. Element name
				tag_output.extend (Bracket.right)					-- 4.
			end
			put_list_output (tag_output, True)
			output_stack.remove
			last_state := State_end_tag
		end

	on_meta_data (version: REAL; a_encoding: EL_ENCODING_BASE)
		--
		do
			Precursor (version, a_encoding)
			put_header (version, a_encoding)
		end

	on_processing_instruction
			--
		do
		end

	on_start_document
			--
		do
		end

	on_start_tag
			--
		local
			tag_output: EL_STRING_8_LIST; i: INTEGER
		do
			put_last_tag (True)
			create tag_output.make (attribute_list.count + 5)

			tag_output.extend (tab * output_stack.count)
			tag_output.extend (Bracket.left)

			tag_output.extend (last_node_name.as_string_8)

			if attached attribute_list.area as area and then area.count > 0 then
				from until i = area.count loop
					tag_output.extend (new_reusable_name_value_pair (area [i]))
					i := i + 1
				end
			end
			tag_output.extend (Bracket.slash_right)

			output_stack.put (tag_output)
			last_state := State_tag
		end

feature {NONE} -- Implementation

	do_scan (action: PROCEDURE)
		do
			action.apply
		end

	escaped_reserved (str: STRING): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			if s.has_member (str, Current) then
				Result := buffer_8.empty
				Xml_escaper.escape_into (str, Result)
			else
				Result := str
			end
		end

	has_reserved (c: CHARACTER_8): BOOLEAN
		do
			inspect c
				when '<', '>', '&', '%'', '%%', '"' then
					Result := True
			else
			end
		end

	new_reusable_name_value_pair (node: EL_DOCUMENT_NODE_STRING): STRING_8
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := buffer_8.empty
			Result.append_character (' ')
			Result.append (node.raw_name)
			Result.append (Value_equals_separator)
			if s.has_member (node, Current) then
				Xml_escaper.escape_into (node, Result)
			else
				Result.append (node)
			end
			Result.append_character ('"')
			Result := Result.twin
		end

	put_content (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			if node.has (New_line_character) then
				output.put_new_line
				put_content_lines (node, False)
				last_state := State_multi_line_content
			else
				put_single_line (node)
				last_state := State_content
			end
		end

	put_content_lines (node: EL_DOCUMENT_NODE_STRING; tabbed: BOOLEAN)
		local
			escaped_text: STRING
		do
			escaped_text := escaped_reserved (node)
			if buffer_8.is_same (escaped_text) then
				escaped_text.adjust
			else
				escaped_text := buffer_8.empty
				node.append_adjusted_to (escaped_text)
			end

			Line_splitter.set_target (escaped_text)
			across Line_splitter as list loop
				if tabbed then
					output.put_string (tab * (output_stack.count + 1))
				end
				put_output_string (list.item, True)
				output.put_new_line
			end
		end

	put_header (version: REAL; a_encoding: EL_ENCODING_BASE)
		--
		local
			xml: XML_ROUTINES
		do
			if attached encodeable_output as l_output then
				if l_output.encoded_as_utf (8) then
					l_output.put_bom
				end
				l_output.put_string (xml.header (version, l_output.encoding_name))
			else
				if a_encoding.encoded_as_utf (8) then
					output.put_string ({UTF_CONVERTER}.Utf_8_bom_to_string_8)
				end
				output.put_string (xml.header (version, a_encoding.name))
			end
			output.put_new_line
		end

	put_last_tag (append_new_line: BOOLEAN)
			--
		local
			last_tag_output: EL_STRING_8_LIST
		do
			if not output_stack.is_empty then
				last_tag_output := output_stack.item
				if last_tag_output.last = Bracket.slash_right then
					last_tag_output.finish
					last_tag_output.replace (Bracket.right)
					put_list_output (last_tag_output, append_new_line)
				end
			end
		end

	put_list_output (tag_output: EL_STRING_8_LIST; append_new_line: BOOLEAN)
			--
		local
			i: INTEGER
		do
			from i := 1 until i > tag_output.count loop
				put_output_string (tag_output.i_th (i), True)
				i := i + 1
			end
			if append_new_line then
				output.put_new_line
			end
		end

	put_output_string (a_str: STRING; is_escaped: BOOLEAN)
		local
			str: STRING
		do
			if is_escaped then
				str := a_str
			else
				str := escaped_reserved (a_str)
			end
			if attached encodeable_output as l_output and then l_output.encoding /= encoding
				and then attached not cursor_8 (str).all_ascii
				and then attached buffer.empty as z_str
			then
				z_str.append_encoded (str, encoding)
				l_output.put_string (z_str)
			else
				output.put_string (str)
			end
		end

	put_single_line (node: EL_DOCUMENT_NODE_STRING)
		do
			put_output_string (node, False)
		end

	set_output (a_output: IO_MEDIUM)
		do
			output := a_output
			if attached {EL_OUTPUT_MEDIUM} a_output as medium then
				encodeable_output := medium
			end
		end

feature {NONE} -- Internal attributes

	buffer: EL_ZSTRING_BUFFER

	buffer_8: EL_STRING_8_BUFFER

	encodeable_output: detachable EL_OUTPUT_MEDIUM

	last_queue_item_is_new_line: BOOLEAN

	last_queue_item_is_text: BOOLEAN

	last_state: INTEGER

	output: IO_MEDIUM

	output_stack: ARRAYED_STACK [EL_STRING_8_LIST]

feature {NONE} -- States

	State_comment: INTEGER = 4

	State_content: INTEGER = 3

	State_end_tag: INTEGER = 2

	State_multi_line_content: INTEGER = 5

	State_tag: INTEGER = 1

feature {NONE} -- Constants

	Line_splitter: EL_SPLIT_ON_CHARACTER [STRING]
		once
			create Result.make (Empty_string_8, New_line_character)
		end

	New_line_character: CHARACTER_8 = '%N'

	Value_equals_separator: STRING = " = %""

end