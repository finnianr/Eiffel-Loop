note
	description: "Xml text generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 9:21:26 GMT (Thursday 7th May 2020)"
	revision: "9"

class
	EL_XML_TEXT_GENERATOR

inherit
	EL_XML_DOCUMENT_SCANNER
		export
			{NONE} all
		redefine
			make_default
		end

	EL_MODULE_LIO

	EL_XML_ROUTINES
		rename
			encoding as xml_encoding
		export
			{NONE} all
		end

	EL_MODULE_UTF

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			create output_stack.make (10)
			Precursor
		end

feature -- Basic operations

	convert_stream (a_input: IO_MEDIUM; a_output: like output)
			--
		require
			valid_input: a_input.is_open_read and a_input.is_readable
			valid_output: a_output.is_open_write and a_output.is_writable
		do
			output := a_output
			scan_from_stream (a_input)
		end

	convert_lines (lines: ITERABLE [READABLE_STRING_GENERAL]; a_output: like output)
			--
		require
			valid_output: a_output.is_open_write and a_output.is_writable
		do
			output := a_output
			scan_from_lines (lines)
		end

feature {NONE} -- Parsing events

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		do
--			if encoding_type ~ Encoding_utf and then encoding = 8 then
--				put BOM
--			end
			output.put_string (Declaration_template #$ [Decimal_formatter.formatted (version), encoding_name])
			output.put_new_line
		end

	on_start_document
			--
		do
		end

	on_end_document
			--
		do
		end

	on_start_tag
			--
		local
			tag_output: EL_ZSTRING_LIST
		do
			put_last_tag (True)
			create tag_output.make (attribute_list.count + 5)

			tag_output.extend (tab_indent (output_stack.count))
			tag_output.extend (Left_angle_bracket)
			tag_output.extend (last_node_name.string)

			from attribute_list.start until attribute_list.after loop
				tag_output.extend (attribute_pair_string (attribute_list.node))
				attribute_list.forth
			end
			tag_output.extend (Empty_element_end)

			output_stack.put (tag_output)
			last_state := State_tag
		end

	on_end_tag
			--
		local
			last_tag_output, tag_output: EL_ZSTRING_LIST
		do
			last_tag_output := output_stack.item
			if last_tag_output.last = Empty_element_end then
				tag_output := last_tag_output
			else
				create tag_output.make (4)
				if last_state /= State_content then
					tag_output.extend (last_tag_output [1]) 		-- 1. Tabs
				end
				tag_output.extend (Close_element_start)			-- 2.
				tag_output.extend (last_tag_output [3]) 			-- 3. Element name
				tag_output.extend (Right_angle_bracket)			-- 4.
			end
			put_output (tag_output, True)
			output_stack.remove
			last_state := State_end_tag
		end

	on_content
			--
		do
			put_last_tag (False)
			put_last_node_text
		end

	on_comment
			--
		local
			has_multiple_lines: BOOLEAN
			line_list: like new_line_list
		do
			has_multiple_lines := last_node_text.has (New_line_character)
			put_last_tag (True)
			output.put_raw_string_8 (tab_indent (output_stack.count))
			output.put_raw_string_8 ("<!--")
			if has_multiple_lines then
				output.put_new_line
				line_list := new_line_list (last_node_text)
				from line_list.start until line_list.after loop
					output.put_raw_string_8 (tab_indent (output_stack.count + 1))
					output.put_string (line_list.item.escaped (xml_escaper))
					output.put_new_line
					line_list.forth
				end
				output.put_raw_string_8 (tab_indent (output_stack.count))
			else
				put_last_node_text
			end
			output.put_raw_string_8 ("-->")
			output.put_new_line
			last_state := State_comment
		end

	on_processing_instruction
			--
		do
		end

feature {NONE} -- Implementation

	attribute_pair_string (attribute_node: EL_XML_ATTRIBUTE_NODE): ZSTRING
			--
		do
			create Result.make (attribute_node.name.count + attribute_node.to_string_32.count + 6)
			Result.append_character (' ')
			Result.append_string_general (attribute_node.name)
			Result.append_string_general (once " = %"")
			Result.append_string_general (escaped_attribute (attribute_node.to_string_32))
			Result.append_character ('"')
		end

	new_line_list (lines: STRING_32): EL_ZSTRING_LIST
		do
			create Result.make_with_separator (lines, New_line_character, False)
		end

	put_last_tag (append_new_line: BOOLEAN)
			--
		local
			last_tag_output: EL_ZSTRING_LIST
		do
			if not output_stack.is_empty then
				last_tag_output := output_stack.item
				if last_tag_output.last = Empty_element_end then
					last_tag_output.finish
					last_tag_output.replace (Right_angle_bracket)
					put_output (last_tag_output, append_new_line)
				end
			end
		end

	put_output (tag_output: EL_ZSTRING_LIST; append_new_line: BOOLEAN)
			--
		local
			i: INTEGER
		do
			from i := 1 until i > tag_output.count loop
				output.put_string (tag_output.i_th (i))
				i := i + 1
			end
			if append_new_line then
				output.put_new_line
			end
		end

	put_last_node_text
			--
		local
			line_list: like new_line_list
			line: ZSTRING
		do
			if last_node_text.has (New_line_character) then
				line_list := new_line_list (last_node_text)
				output.put_new_line
				from line_list.start until line_list.after loop
					output.put_string (line_list.item.escaped (xml_escaper))

					line_list.forth
					if not line_list.after then
						output.put_new_line
					end
				end
				output.put_new_line
				last_state := State_multi_line_content
			else
				line := last_node_text
				output.put_string (line.escaped (xml_escaper))
				last_state := State_content
			end
		end

	tab_indent (tab_count: INTEGER): STRING
			--
		local
			i: INTEGER
		do
			create Result.make (tab_count)
			from i := 1 until i > tab_count loop
				Result.append_character ('%T')
				i := i + 1
			end
		end

	output_stack: ARRAYED_STACK [EL_ZSTRING_LIST]

	output: EL_OUTPUT_MEDIUM

	last_queue_item_is_text: BOOLEAN

	last_queue_item_is_new_line: BOOLEAN

	last_state: INTEGER

feature {NONE} -- Constants

	Declaration_template: ZSTRING
			--
		once
			Result := "[
				<?xml version = "#" encoding = "#"?>
			]"
		end

	Decimal_formatter: FORMAT_DOUBLE
			--
		once
			create Result.make (3, 1)
		end

	New_line: ZSTRING
		once
			Result := "%N"
		end

	New_line_character: CHARACTER_32 = '%N'

	Comment_end: ZSTRING
		once
			Result := "-->"
		end

	Empty_element_end: ZSTRING
		once
			Result := "/>"
		end

	Left_angle_bracket: ZSTRING
		once
			Result := "<"
		end

	Right_angle_bracket: ZSTRING
		once
			Result := ">"
		end

	Close_element_start: ZSTRING
		once
			Result := "</"
		end

	State_tag: INTEGER = unique

	State_end_tag: INTEGER = unique

	State_content: INTEGER = unique

	State_comment: INTEGER = unique

	State_multi_line_content: INTEGER = unique

end
