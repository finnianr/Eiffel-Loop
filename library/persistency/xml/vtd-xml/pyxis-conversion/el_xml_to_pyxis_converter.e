note
	description: "XML to pyxis converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "16"

class
	EL_XML_TO_PYXIS_CONVERTER

inherit
	EL_EIFFEL_TEXT_PATTERN_FACTORY
		rename
			token as token_pattern
		export
			{NONE} all
		end

	EL_VTD_CONSTANTS

	EL_MODULE_LIO

	EL_COMMAND

create
	make, make_default

feature {EL_COMMAND_CLIENT} -- Initiliazation

	make (a_source_path: like source_path)
			--
		do
			make_default
			set_source_path (a_source_path)
		end

	make_default
		do
			create text_matcher.make
			create attributes
			numeric_constant_pattern := numeric_constant
			xml_identifier_or_numeric_constant_pattern := one_of (<< xml_identifier, numeric_constant >>)

			create last_attribute_name.make_empty
			next_node_action := agent put_pyxis_doc
			node_actions := node_actions_table

			create source_path
		end

feature -- Access

	output_path: FILE_PATH

	source_path: FILE_PATH

	source_encoding: EL_MARKUP_ENCODING
		do
			create Result.make_from_file (source_path)
		end

feature -- Element change

 	set_source_path (a_source_path: like source_path)
 			--
 		do
 			source_path := a_source_path
			if source_path.has_extension ("ecf") then
				output_path := source_path.with_new_extension ("pecf")
			else
				output_path := source_path.twin
				output_path.add_extension ("pyx")
			end
			create xdoc.make_from_file (source_path)
			if xdoc.parse_failed and is_lio_enabled then
				lio.put_new_line
				lio.put_line (xdoc.error_message)
			end
 		end

feature -- Basic operations

	execute
			--
		require else
			convertable: is_convertable
		local
			i, l_type: INTEGER; node_text: ZSTRING
		do
			if is_lio_enabled then
				lio.put_path_field ("Converting", source_path)
				lio.put_new_line
			end
			create out_file.make_open_write (output_path)
			out_file.set_encoding_from_other (source_encoding)
			last_node_type := 0; next_node_type := 0; node_depth := 0; attribute_node_depth := 0
			last_attribute_name.wipe_out
			token_count := xdoc.token_count
			next_node_action := agent put_pyxis_doc
			from i := 1 until i > token_count loop
				node_depth := xdoc.token_depth (i).max (0)
				l_type := xdoc.token_type (i); node_text := xdoc.node_text_at_index (i)
				next_node_action.call ([i, l_type, node_text])
				i := i + 1
			end
			out_file.close
		end

feature -- Status query

	is_convertable: BOOLEAN
			-- True if input file is convertable to Pyxis format
		do
			Result := not xdoc.parse_failed
		end

	is_last_node_an_attribute_value: BOOLEAN
		do
			Result := last_node_type = Token.attr_val or last_node_type = Token.dec_attr_val
		end

feature {NONE} -- Parser state actions

	assign_value_to_attribute (i, a_type: INTEGER; node_text: ZSTRING)
		require
			valid_type: Attribute_value_types.has (a_type)
		do
			attributes [last_attribute_name] := node_text
			if i = token_count then
				put_attributes; attributes.wipe_out
				next_node_action := agent try_nothing
			else
				next_node_action := agent save_attribute_name
			end
		end

	call_action_for_type (i, a_type: INTEGER; node_text: ZSTRING)
		do
			node_actions.search (a_type)
			if node_actions.found then
				if i < token_count then
					next_node_type := xdoc.token_type (i + 1)
				end
				node_actions.found_item.call ([node_text])
				last_node_type := a_type

			elseif Attribute_name_types.has (a_type) then
				attribute_node_depth := node_depth + 1
				save_attribute_name (i, a_type, node_text)
			end
		end

	put_pyxis_doc (i, a_type: INTEGER; node_text: ZSTRING)
		require
			is_first_node: i = 1
		do
			out_file.put_string ("pyxis-doc:")
			out_file.put_new_line
			next_node_action := agent call_action_for_type
		end

	save_attribute_name (i, a_type: INTEGER; node_text: ZSTRING)
		do
			if Attribute_name_types.has (a_type) then
				last_attribute_name := node_text.twin
				last_attribute_name.replace_character (':', '.')
				next_node_action := agent assign_value_to_attribute
			else
				put_attributes; attributes.wipe_out
				next_node_action := agent call_action_for_type
				call_action_for_type (i, a_type, node_text)
			end
		end

	try_nothing (i, a_type: INTEGER; node_text: ZSTRING)
		do
		end

feature {NONE} -- Node events

	on_character_data (a_data: ZSTRING)
		local
			lines: LIST [ZSTRING]
		do
			if is_last_node_an_attribute_value then
				out_file.put_new_line
			end
			lines := a_data.split_list ('%N')
			if lines.count > 1 then
				trim_lines (lines)
				if not lines.is_empty then
					put_indent (node_depth + 1); put_line (Triple_quote)
					across lines as line loop
						put_indent (node_depth + 2)
						line.item.left_adjust
						put_line (line.item)
					end
					put_indent (node_depth + 1); put_line (Triple_quote)
				end
			else
				put_indent (node_depth + 1)
				put_line (adjusted_value (lines.first, True, False))
			end
		end

	on_comment_text (a_comment: ZSTRING)
		local
			l_lines: LIST [ZSTRING]
		do
			out_file.put_new_line
			l_lines := a_comment.split_list ('%N')
			trim_lines (l_lines)
			across l_lines as line loop
				line.item.left_adjust
				if line.item.is_empty then
					out_file.put_new_line
				else
					put_indent (node_depth + 1)
					out_file.put_string ("# ")
					put_line (line.item)
				end
			end
		end

	on_starting_tag (a_name: ZSTRING)
		local
			python_name: ZSTRING
		do
			if is_last_node_an_attribute_value then
				out_file.put_new_line
			end
			if not (a_name ~ last_starting_tag and last_node_type = Token.character_data)
				or else next_node_type = Token.attribute_name
			then
				put_indent (node_depth)
				python_name := a_name.twin
				python_name.replace_character (':', '.')
				out_file.put_string (python_name)
				out_file.put_character_8 (':')
				out_file.put_new_line
			end
			last_starting_tag := a_name
		end

feature {NONE} -- Implementation

	adjusted_value (a_string: ZSTRING; identifiers_in_quotes, escape_backslash_before_quote: BOOLEAN): ZSTRING
			-- Put quotes around string unless it looks like a number or identifier
		local
			quote: CHARACTER
		do
			if identifiers_in_quotes then
				text_matcher.set_pattern (numeric_constant)
			else
				text_matcher.set_pattern (xml_identifier_or_numeric_constant_pattern)
			end
			if text_matcher.is_match (a_string) and not (a_string.is_empty or a_string.has ('-')) then
				Result := a_string
			else
				if a_string.index_of ('"', 1) > 0 then
					quote := '%''
				else
					quote := '"'
				end
				create Result.make (a_string.count + 2)
				Result.append_character (quote)
				Result.append (a_string)
				Result.append_character (quote)
				if quote = '"' and escape_backslash_before_quote then
					Result.replace_substring_all (Back_slash_quote, Double_back_slash_quote)
				end
			end
		end

	node_actions_table: EL_HASH_TABLE [PROCEDURE [ZSTRING], INTEGER]
		do
			create Result.make (<<
				[Token.starting_tag, agent on_starting_tag],
				[Token.character_data, agent on_character_data],
				[Token.comment, agent on_comment_text]
			>>)
		end

	put_attributes
		local
			name_value_text, line: ZSTRING
		do
			create line.make (attributes.count * 60)
			across attributes.current_keys as name loop
				name_value_text := name.item + " = " + adjusted_value (attributes [name.item], False, True)
				if line.count + name_value_text.count < 80 then
					if not line.is_empty then
						line.append (Colon_separator)
					end
					line.append (name_value_text)
				else
					if not line.is_empty then
						put_indent (attribute_node_depth)
						put_line (line)
					end
					line := name_value_text
				end
			end
			put_indent (attribute_node_depth)
			put_line (line)
		end

	put_indent (a_node_depth: INTEGER)
		local
			tab_indent: ZSTRING
		do
			create tab_indent.make_filled ('%T', a_node_depth)
			out_file.put_string (tab_indent)
		end

	put_line (a_line: ZSTRING)
		do
			out_file.put_string (a_line)
			out_file.put_new_line
		end

	trim_lines (lines: LIST [ZSTRING])
			-- Remove leading and trailing empty lines
		do
			lines.do_all (agent {ZSTRING}.left_adjust); lines.do_all (agent {ZSTRING}.right_adjust)
			from lines.start until lines.after or not lines.item.is_empty loop
				if lines.item.is_empty then
					lines.remove
				else
					lines.forth
				end
			end
			from lines.finish until lines.before or not lines.item.is_empty loop
				if lines.item.is_empty then
					lines.remove
				end
				lines.back
			end
		end

	xml_identifier: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				one_of (<< letter, character_literal ('_') >> ),
				zero_or_more (xml_identifier_character)
			>>)
		end

	xml_identifier_character: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
		do
			Result := identifier_character
			Result.extend (character_literal ('-'))
		end

feature {NONE} -- Internal attributes

	attribute_node_depth: INTEGER

	attributes: EL_ZSTRING_HASH_TABLE [ZSTRING]

	last_attribute_name: ZSTRING

	last_node_type: INTEGER

	last_starting_tag: ZSTRING

	next_node_action: PROCEDURE [INTEGER, INTEGER, ZSTRING]

	next_node_type: INTEGER

	node_actions: like node_actions_table

	node_depth: INTEGER

	numeric_constant_pattern: like numeric_constant

	out_file: EL_PLAIN_TEXT_FILE

	text_matcher: EL_TEXT_MATCHER

	token_count: INTEGER

	xdoc: EL_XPATH_ROOT_NODE_CONTEXT

	xml_identifier_or_numeric_constant_pattern: like one_of

feature {NONE} -- Constants

	Attribute_name_types: ARRAY [INTEGER]
		once
			Result := << Token.attribute_name, Token.dec_attr_name, Token.attr_ns >>
		end

	Attribute_value_types: ARRAY [INTEGER]
		once
			Result := << Token.attr_val, Token.dec_attr_val >>
		end

	Back_slash_quote: ZSTRING
		once
			Result := "\%""
		end

	Colon_separator: ZSTRING
		once
			Result := "; "
		end

	Double_back_slash_quote: ZSTRING
		once
			Result := "\\%""
		end

	Is_zstring_source: BOOLEAN = True

	Triple_quote: ZSTRING
		once
			create Result.make_filled ('"', 3)
		end
end