note
	description: "Summary description for {PYXIS_TO_XML_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:01 GMT (Monday 22nd July 2013)"
	revision: "4"

class
	EL_XML_TEXT_GENERATOR

inherit
	EL_XML_DOCUMENT_SCANNER
		export
			{NONE} all
		redefine
			make_last_node
		end

	EL_MODULE_STRING
		export
			{NONE} all
		end

	EL_MODULE_LOG
		export
			{NONE} all
		end

	EL_MODULE_XML
		export
			{NONE} all
		end

	EL_MODULE_UTF
		export
			{NONE} all
		end

create
	make, make_binary_source, make_delimited_source

feature {NONE} -- Initialization

	make_last_node
			--
		do
			Precursor
			create output_stack.make (10)
		end

feature -- Basic operations

	convert_stream (a_input, a_output: IO_MEDIUM)
			--
		require
			valid_input: a_input.is_open_read and a_input.is_readable
			valid_output: a_output.is_open_write and a_output.is_writable
		do
			output := a_output
			scan_from_stream (a_input)
		end

feature {NONE} -- Parsing events

	on_xml_tag_declaration
			--
		do
--			if encoding_type ~ Encoding_utf and then encoding = 8 then
--				put BOM
--			end
			Declaration_template.set_variable (once "VERSION", Decimal_formatter.formatted (xml_version))
			Declaration_template.set_variable (once "ENCODING", encoding_name)
			output.put_string (Declaration_template.substituted)
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
			tag_output: like Type_string_list
		do
			put_last_tag (True)
			create tag_output.make (attribute_list.count + 5)

			tag_output.extend (tab_indent (output_stack.count))
			tag_output.extend (Left_angle_bracket)
			tag_output.extend (last_node_name.string)

			from attribute_list.start until attribute_list.after loop
				tag_output.extend (escaped (attribute_node_string (attribute_list.node)))
				attribute_list.forth
			end
			tag_output.extend (Empty_element_end)

			output_stack.put (tag_output)
			last_state := State_tag
		end

	on_end_tag
			--
		local
			last_tag_output, tag_output: like Type_string_list
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
			line_list: LIST [STRING_32]
		do
			has_multiple_lines := last_node_text.has (New_line_character)
			put_last_tag (True)
			output.put_string (tab_indent (output_stack.count))
			output.put_string ("<!--")
			if has_multiple_lines then
				output.put_new_line
				line_list := last_node_text.split ('%N')
				from line_list.start until line_list.after loop
					output.put_string (tab_indent (output_stack.count + 1))
					output.put_string (escaped (line_list.item))
					output.put_new_line
					line_list.forth
				end
				output.put_string (tab_indent (output_stack.count))
			else
				put_last_node_text
			end
			output.put_string ("-->")
			output.put_new_line
			last_state := State_comment
		end

	on_processing_instruction
			--
		do
		end

feature {NONE} -- Implementation

	put_last_tag (append_new_line: BOOLEAN)
			--
		local
			last_tag_output: like Type_string_list
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

	put_output (tag_output: like Type_string_list; append_new_line: BOOLEAN)
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
			line_list: EL_LINE_LIST [STRING_32]
		do
			if last_node_text.has (New_line_character) then
				create line_list.make (last_node_text)
				output.put_new_line
				from line_list.start until line_list.after loop
					output.put_string (escaped (line_list.item))

					line_list.forth
					if not line_list.after then
						output.put_new_line
					end
				end
				output.put_new_line
				last_state := State_multi_line_content
			else
				output.put_string (escaped (last_node_text))
				last_state := State_content
			end
		end

	escaped (a_string: STRING_32): STRING
		local
			l_result: EL_ASTRING
		do
			l_result := XML.basic_escaped (a_string)
			if encoding_type = parse_event_source.Encoding_ISO_8859 then
				Result := l_result.to_latin1

			elseif encoding_type = parse_event_source.Encoding_utf then
				if encoding = 8 then
					Result := l_result.to_utf8
				end
			else
				create Result.make_empty
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

	attribute_node_string (attribute_node: EL_XML_ATTRIBUTE_NODE): STRING_32
			--
		local
			template: like Attribute_template
		do
			template := Attribute_template
			template.set_variable (once "NAME", attribute_node.name)
			template.set_variable (once "VALUE", attribute_node.to_string_32)
			Result := template.substituted
		end

	output_stack: ARRAYED_STACK [like Type_string_list]

	output: IO_MEDIUM

	last_queue_item_is_text: BOOLEAN

	last_queue_item_is_new_line: BOOLEAN

	last_state: INTEGER

feature {NONE} -- Constants

	Attribute_template: EL_SUBSTITUTION_TEMPLATE [STRING_32]
			--
		once
			create Result.make (" $NAME = %"$VALUE%"")
		end

	Declaration_template: EL_SUBSTITUTION_TEMPLATE [STRING]
			--
		once
			Result := "[
				<?xml version = "$VERSION" encoding = "$ENCODING"?>
			]"
		end

	Decimal_formatter: FORMAT_DOUBLE
			--
		once
			create Result.make (3, 1)
		end

	New_line: STRING_32 = "%N"

	New_line_character: CHARACTER_32 = '%N'

	Comment_end: STRING_32 = "-->"

	Empty_element_end: STRING_32 = "/>"

	Left_angle_bracket: STRING_32 = "<"

	Right_angle_bracket: STRING_32 = ">"

	Close_element_start: STRING_32 = "</"

	State_tag: INTEGER = unique

	State_end_tag: INTEGER = unique

	State_content: INTEGER = unique

	State_comment: INTEGER = unique

	State_multi_line_content: INTEGER = unique

feature {NONE} -- Constants

	Type_string_list: ARRAYED_LIST [STRING_32]
		once
		end

end
