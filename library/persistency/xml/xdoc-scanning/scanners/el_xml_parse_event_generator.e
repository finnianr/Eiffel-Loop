note
	description: "Xml parse event generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_XML_PARSE_EVENT_GENERATOR

inherit
	EL_XML_DOCUMENT_SCANNER
		redefine
			event_source
		end

	EL_XML_PARSE_EVENT_STREAM

	EL_MODULE_LIO

create
	make_with_output

feature {NONE} -- Implementation

	make_with_output (output_stream: like event_stream)
			--
		do
			make ({like event_source})
			create name_index_table.make (Name_index_table_size)
			name_index_table.compare_objects
			event_stream := output_stream
		end

feature -- Basic operations

	send_file (file_path: EL_FILE_PATH)
			--
		local
			xml_file: PLAIN_TEXT_FILE
		do
			create xml_file.make_open_read (file_path)
			send (xml_file)
			xml_file.close
		end

	send_string (string: STRING)
			--
		do
			lio.enter ("send_string")
			scan (string)
			lio.exit
		end

	send (in_stream: IO_MEDIUM)
			--
		do
			lio.enter ("send")
			scan_from_stream (in_stream)
			lio.exit
		end

	send_object (object: EVOLICITY_SERIALIZEABLE_AS_XML)
			--
		do
			lio.enter_with_args ("send_object", << object.generator >>)
			event_source.parse_from_serializable_object (object)
			lio.exit
		end

	close
			--
		do
			event_stream.close
		end

feature {NONE} -- Implementation

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		do
		end

	on_start_tag
			--
		do
			lio.enter ("on_start_tag")
			put_named_parse_event (
				last_node_name,
				Parse_event_existing_start_tag, Parse_event_new_start_tag
			)
			from attribute_list.start until attribute_list.after loop
				put_named_parse_event (
					attribute_list.node.name,
					Parse_event_existing_attribute_name, Parse_event_new_attribute_name
				)
				put_parse_event (attribute_list.node.raw_content.count, Parse_event_attribute_text)
				event_stream.put_string (attribute_list.node.raw_content)
				lio.put_string_field (attribute_list.node.xpath_name, attribute_list.node.to_string)
				lio.put_new_line
				attribute_list.forth
			end
			lio.exit
		end

	on_end_tag
			--
		do
			lio.enter ("on_end_tag")
			put_parse_event (0, Parse_event_end_tag)
			lio.exit
		end

	on_content
			--
		do
			lio.enter ("on_content")
			put_parse_event (last_node_text.count, Parse_event_text)
			event_stream.put_string (last_node_text)
			lio.exit
		end

	on_comment
			--
		do
			lio.enter ("on_comment")
			put_parse_event (last_node_text.count, Parse_event_comment_text)
			event_stream.put_string (last_node_text)
			lio.exit
		end

	on_processing_instruction
			--
		do
			lio.enter ("on_processing_instruction")
			put_named_parse_event (
				last_node_name, Parse_event_existing_processing_instruction, Parse_event_new_processing_instruction
			)
			event_stream.put_natural_16 (last_node_text.count.to_natural_16)
			event_stream.put_string (last_node_text)
			lio.exit
		end

	on_start_document
			--
		do
			lio.enter ("on_start_document")
			name_index_table.wipe_out
			put_parse_event (0, Parse_event_start_document)
			lio.exit
		end

	on_end_document
			--
		do
			lio.enter ("on_end_document")
			put_parse_event (0, Parse_event_end_document)
			lio.exit
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
				event_stream.put_string (name)
			end
		end

	put_parse_event (count_or_index, code: INTEGER)
			--
		require
			code_fits_in_4_bits: code >= 1 and code <= 16
		do
			event_stream.put_natural_16 (((count_or_index |<< 4) | (code - 1)).to_natural_16)
		end

feature {NONE} -- Implementation: attributes

	name_index_table: HASH_TABLE [INTEGER, STRING]

	event_source: EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM

end
