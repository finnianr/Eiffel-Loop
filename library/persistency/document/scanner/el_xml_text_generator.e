note
	description: "Generate XML document from node scan source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-16 9:10:36 GMT (Wednesday 16th August 2023)"
	revision: "27"

class
	EL_XML_TEXT_GENERATOR

inherit
	EL_DOCUMENT_NODE_SCANNER
		export
			{NONE} all
		redefine
			make_default, on_meta_data
		end

	EL_MODULE_LIO; EL_MODULE_REUSEABLE

	EL_CHARACTER_CONSTANTS; EL_STRING_8_CONSTANTS; XML_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			create output_stack.make (10)
			pool := Default_pool
			Precursor
		end

feature -- Basic operations

	convert_lines (lines: ITERABLE [READABLE_STRING_GENERAL]; a_output: like output)
			--
		require
			valid_output: a_output.is_open_write and a_output.is_writable
		do
			output := a_output
			do_scan (agent	scan_from_lines (lines))
		ensure
			stack_empty: output_stack.is_empty
		end

	convert_stream (a_input, a_output: IO_MEDIUM)
			--
		require
			valid_input: a_input.is_open_read and a_input.is_readable
			valid_output: a_output.is_open_write and a_output.is_writable
		do
			output := a_output
			do_scan (agent	scan_from_stream (a_input))
		ensure
			stack_empty: output_stack.is_empty
		end

	convert_text (text: STRING; a_output: like output)
			--
		require
			valid_output: a_output.is_open_write and a_output.is_writable
		do
			output := a_output
			do_scan (agent	scan (text))
		ensure
			stack_empty: output_stack.is_empty
		end

feature {NONE} -- Parsing events

	on_comment
			--
		do
			put_last_tag (True)
			output.put_string (Tab * output_stack.count)
			output.put_string (Comment_open)
			if attached last_node as node then
				if node.has (New_line_character) then
					output.put_new_line
					put_content_lines (node, True)
					output.put_string (Tab * output_stack.count)
				else
					put_single_line (node)
				end
			end
			output.put_string (Comment_close)
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
			if last_tag_output.last = Empty_tag_marker then
				tag_output := last_tag_output
			else
				create tag_output.make (4)
				if last_state /= State_content then
					tag_output.extend (last_tag_output [1]) 		-- 1. Tabs
				end
				tag_output.extend (Close_tag_marker)				-- 2.
				tag_output.extend (last_tag_output [3]) 			-- 3. Element name
				tag_output.extend (Right_angle_bracket)			-- 4.
			end
			put_output (tag_output, True)
			output_stack.remove
			last_state := State_end_tag
		end

	on_meta_data (version: REAL; a_encoding: EL_ENCODING_BASE)
		--
		do
			Precursor (version, a_encoding)
			if a_encoding.encoded_as_utf (8) then
				output.put_string ({UTF_CONVERTER}.Utf_8_bom_to_string_8)
			end
			Header_template.put (Var_version, Decimal_formatter.formatted (version))
			Header_template.put (Var_encoding, a_encoding.name)
			output.put_string (Header_template.substituted)
			output.put_new_line
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

			tag_output.extend (Tab * output_stack.count)
			tag_output.extend (Left_angle_bracket)

			tag_output.extend (pool.borrowed_item)
			tag_output.last.append (last_node_name)

			if attached attribute_list.area as area and then area.count > 0 then
				from until i = area.count loop
					tag_output.extend (new_reusable_name_value_pair (area [i]))
					i := i + 1
				end
			end
			tag_output.extend (Empty_tag_marker)

			output_stack.put (tag_output)
			last_state := State_tag
		end

feature {NONE} -- Implementation

	do_scan (action: PROCEDURE)
		do
			across Reuseable.string_8_pool as scope loop
				pool := scope
				action.apply
			end
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
			text: STRING
		do
			across Reuseable.string_8 as reuse loop
				text := reuse.item
				node.append_adjusted_to (text)

				Line_splitter.set_target (Xml_escaper.escaped (text, False))
				across Line_splitter as list loop
					if tabbed then
						output.put_string (Tab * (output_stack.count + 1))
					end
					output.put_string (list.item)
					output.put_new_line
				end
			end
		end

	put_single_line (node: EL_DOCUMENT_NODE_STRING)
		do
			across Reuseable.string_8 as reuse loop
				if attached reuse.item as text then
					Xml_escaper.escape_into (node, text)
					output.put_string (text)
				end
			end
		end

	put_last_tag (append_new_line: BOOLEAN)
			--
		local
			last_tag_output: EL_STRING_8_LIST
		do
			if not output_stack.is_empty then
				last_tag_output := output_stack.item
				if last_tag_output.last = Empty_tag_marker then
					last_tag_output.finish
					last_tag_output.replace (Right_angle_bracket)
					put_output (last_tag_output, append_new_line)
				end
			end
		end

	put_output (tag_output: EL_STRING_8_LIST; append_new_line: BOOLEAN)
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

	new_reusable_name_value_pair (node: EL_DOCUMENT_NODE_STRING): STRING_8
		do
			Result := pool.borrowed_item
			Result.append_character (' ')
			Result.append (node.raw_name)
			Result.append (Value_equals_separator)
			XML_escaper.escape_into (node, Result)
			Result.append_character ('"')
		end

feature {NONE} -- Internal attributes

	last_queue_item_is_new_line: BOOLEAN

	last_queue_item_is_text: BOOLEAN

	last_state: INTEGER

	output: IO_MEDIUM

	output_stack: ARRAYED_STACK [EL_STRING_8_LIST]

	pool: like Default_pool

feature {NONE} -- States

	State_comment: INTEGER = 4

	State_content: INTEGER = 3

	State_end_tag: INTEGER = 2

	State_multi_line_content: INTEGER = 5

	State_tag: INTEGER = 1

feature {NONE} -- Constants

	Default_pool: EL_STRING_POOL_SCOPE_CURSOR [STRING]
		do
			create Result.make (create {EL_STRING_FACTORY_POOL [STRING]}.make (0))
		end

	Decimal_formatter: FORMAT_DOUBLE
			--
		once
			create Result.make (3, 1)
		end

	Line_splitter: EL_SPLIT_ON_CHARACTER [STRING]
		once
			create Result.make (Empty_string_8, New_line_character)
		end

	New_line_character: CHARACTER_8 = '%N'

	Value_equals_separator: STRING = " = %""

end