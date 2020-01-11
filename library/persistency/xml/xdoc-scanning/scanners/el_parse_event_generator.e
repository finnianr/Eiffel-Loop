note
	description: "General parse event generator that can use Pyxis or XML as input source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-10 22:51:39 GMT (Friday 10th January 2020)"
	revision: "1"

class
	EL_PARSE_EVENT_GENERATOR

inherit
	EL_XML_DOCUMENT_SCANNER
		redefine
			make_default
		end

	EL_PARSE_EVENT_CONSTANTS
		rename
			Default_io_medium as Default_output
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create name_index_table.make (Name_index_table_size)
			name_index_table.compare_objects
			output := Default_output
		end

feature -- Basic operations

	send_file (file_path: EL_FILE_PATH; a_output: like output)
			--
		local
			file_in: PLAIN_TEXT_FILE
		do
			create file_in.make_open_read (file_path)
			send (file_in, a_output)
			file_in.close
		end

	send_string (string: STRING; a_output: like output)
			--
		do
			output := a_output
			if is_lio_enabled then
				lio.put_line ("send_string (string: STRING)")
			end
			scan (string)
			output := Default_output
		end

	send (in_stream: IO_MEDIUM; a_output: like output)
			--
		do
			output := a_output
			if is_lio_enabled then
				lio.put_line ("send (in_stream: IO_MEDIUM)")
			end
			scan_from_stream (in_stream)
			output := Default_output
		end

feature {NONE} -- Implementation

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		do
		end

	on_start_tag
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_start_tag")
			end
			put_named_parse_event (
				last_node_name,
				PE_existing_start_tag, PE_new_start_tag
			)
			from attribute_list.start until attribute_list.after loop
				put_named_parse_event (
					attribute_list.node.name,
					PE_existing_attribute_name, PE_new_attribute_name
				)
				put_parse_event (attribute_list.node.raw_content.count, PE_attribute_text)
				output.put_string (attribute_list.node.raw_content)
				if is_lio_enabled then
					lio.put_string_field (attribute_list.node.xpath_name, attribute_list.node.to_string)
					lio.put_new_line
				end
				attribute_list.forth
			end
		end

	on_end_tag
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_end_tag")
			end
			put_parse_event (0, PE_end_tag)
		end

	on_content
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_content")
			end
			put_parse_event (last_node_text.count, PE_text)
			output.put_string (last_node_text)
		end

	on_comment
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_comment")
			end
			put_parse_event (last_node_text.count, PE_comment_text)
			output.put_string (last_node_text)
		end

	on_processing_instruction
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_processing_instruction")
			end
			put_named_parse_event (
				last_node_name, PE_existing_processing_instruction, PE_new_processing_instruction
			)
			output.put_natural_16 (last_node_text.count.to_natural_16)
			output.put_string (last_node_text)
		end

	on_start_document
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_start_document")
			end
			name_index_table.wipe_out
			put_parse_event (0, PE_start_document)
		end

	on_end_document
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_end_document")
			end
			put_parse_event (0, PE_end_document)
		end

feature {NONE} -- Implementation

	put_named_parse_event (name: STRING; existing_name_code, new_name_code: INTEGER)
			--
		local
			name_index: INTEGER
		do
			if name_index_table.has_key (name) then
				name_index := name_index_table.found_item
				put_parse_event (name_index, existing_name_code)
			else
				name_index := name_index_table.count + 1
				name_index_table.extend (name_index, name)
				put_parse_event (name.count, new_name_code)
				output.put_string (name)
			end
		end

	put_parse_event (count_or_index, code: INTEGER)
			--
		require
			code_fits_in_4_bits: code >= 1 and code <= 16
			output_set: output /= Default_output
		do
			output.put_natural_16 (((count_or_index |<< 4) | (code - 1)).to_natural_16)
		end

feature {NONE} -- Implementation: attributes

	output: IO_MEDIUM

	name_index_table: HASH_TABLE [INTEGER, STRING]
end
