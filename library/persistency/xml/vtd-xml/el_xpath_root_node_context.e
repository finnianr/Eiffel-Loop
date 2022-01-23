note
	description: "Top level object representing an XML document"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 11:50:44 GMT (Sunday 23rd January 2022)"
	revision: "13"

class
	EL_XPATH_ROOT_NODE_CONTEXT

inherit
	EL_XPATH_NODE_CONTEXT
		rename
			Token as Token_enum
		redefine
			default_create
		end

	READABLE_INDEXABLE [INTEGER]
		rename
			item as token_type,
			lower as token_index_lower,
			upper as token_index_upper,
			valid_index as valid_token_index
		undefine
			default_create
		redefine
			new_cursor
		end

	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		undefine
			default_create
		end

	EXCEPTION_MANAGER
		export
			{NONE} all
		undefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM

create
	default_create, make_from_file, make_from_string, make_from_fragment

convert
	make_from_file ({FILE_PATH})

feature {NONE} -- Initaliazation

	default_create
		do
			make_from_string (default_xml)
		end

	make_from_file (a_file_path: FILE_PATH)
			--
		do
			make_from_string (File_system.plain_text (a_file_path))
		end

	make_from_fragment (xml_fragment: STRING; a_encoding: STRING)
		do
			make_from_string (Header_template.substituted_tuple (a_encoding).to_latin_1 + xml_fragment)
		end

	make_from_string (a_xml: STRING)
			--
		local
			l_context_pointer: POINTER; l_encoding_name: STRING
		do
			make_default
			create found_instruction.make_empty; create namespace.make_empty
			if parse_failed then
				parse_namespace_declarations (default_xml)
				document_xml := default_xml
				create error_message.make_from_general (last_exception.description)
			else
				parse_namespace_declarations (a_xml)
				document_xml := a_xml
				create error_message.make_empty
			end

			l_context_pointer := Parser.root_context_pointer (document_xml, namespaces_defined)

			if is_attached (l_context_pointer) then
				make (l_context_pointer, Current)
				create l_encoding_name.make_from_c (c_node_context_encoding_type (l_context_pointer))
				l_encoding_name.append_character ('-')
				l_encoding_name.append_integer (c_node_context_encoding (l_context_pointer))
				set_encoding_from_name (l_encoding_name)
			end
		rescue
			parse_failed := True
			retry
		end

feature -- Token access

	token_string_8 (index: INTEGER): STRING
			--
		do
			Result := wide_string_at_index (index)
		end

	token_string_32 (index: INTEGER): STRING_32
			--
		do
			Result := wide_string_at_index (index)
		end

	token_string (index: INTEGER): ZSTRING
			--
		do
			Result := wide_string_at_index (index)
		end

	new_cursor: EL_DOCUMENT_TOKEN_ITERATOR
		do
			create Result.make (Current)
			Result.start
		end

	token_type (index: INTEGER): INTEGER
		-- alias []
		do
			Result := c_evx_get_token_type (self_ptr, index - 1)
		end

feature -- Access

	document_xml: EL_C_STRING_8

	error_message: ZSTRING

	found_instruction: STRING

feature -- Measurement

	token_index_lower: INTEGER
		do
			Result := 1
		end

	token_index_upper: INTEGER
			--
		do
			Result := c_evx_get_token_count (self_ptr)
		end

	token_depth (index: INTEGER): INTEGER
			--
		require
			valid_index: index >= 1 and index <= token_index_upper
		do
			Result := c_evx_get_token_depth (self_ptr, index - 1)
		end

	word_count (exclude_variable_reference: BOOLEAN; included_attributes: EL_STRING_8_LIST): INTEGER
		-- count of text words in document and in any `included_attributes'
		local
			s: EL_ZSTRING_ROUTINES; l_name: ZSTRING
		do
			create l_name.make_empty
			across Current as token loop
				if token.is_character_data_item then
					Result := Result + s.word_count (token.item_string, True)

				elseif token.is_attribute_name_item then
					l_name := token.item_string_8

				elseif token.is_attribute_value_item and then included_attributes.has (l_name) then
					Result := Result + s.word_count (token.item_string, True)
				end
			end
		end

feature -- Status query

	instruction_found: BOOLEAN

	namespaces_defined: BOOLEAN
			-- Are any namespaces defined in document
		do
			Result := not namespace_urls.is_empty
		end

	parse_failed: BOOLEAN

	valid_token_index (index: INTEGER): BOOLEAN
		do
			Result := token_index_lower <= index and index <= token_index_upper
		end

feature -- Basic operations

	find_instruction (a_name: STRING)
			-- find processing instruction with name
		local
			pi_name_index: INTEGER
		do
			instruction_found := False
			found_instruction.wipe_out
			across Current as token until instruction_found loop
				if token.is_processing_instruction_name_item and then token.item_string_8 ~ a_name then
					pi_name_index := token.cursor_index

				elseif token.is_processing_instruction_value_item and then pi_name_index = (token.cursor_index - 1) then
					found_instruction.append (token.item_string_8)
					instruction_found := true

				end
			end
		end

feature {EL_DOCUMENT_TOKEN_ITERATOR} -- Implementation

	default_xml: STRING
		local
			default_doc: EL_DEFAULT_SERIALIZEABLE_XML
		do
			create default_doc
			Result := default_doc.to_xml
		end

	wide_string_at_index (index: INTEGER): EL_C_WIDE_CHARACTER_STRING
			--
		require
			valid_index: valid_token_index (index)
		do
			Result := wide_string (c_node_text_at_index (self_ptr, index - 1))
		end

feature {NONE} -- Constants

	Header_template: ZSTRING
		once
			Result := "[
				<?xml version="1.0" encoding="#"?>
			]"
		end

	Parser: EL_VTD_XML_PARSER
			--
		once
			create Result.make
		end

end