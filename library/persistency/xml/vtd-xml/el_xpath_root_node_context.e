note
	description: "Top level object representing an XML document"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-01 18:21:06 GMT (Tuesday 1st February 2022)"
	revision: "14"

class
	EL_XPATH_ROOT_NODE_CONTEXT

inherit
	EL_XPATH_NODE_CONTEXT
		rename
			Token as Token_enum
		undefine
			namespace_table
		redefine
			default_create
		end

	EL_LAZY_ATTRIBUTE
		rename
			item as namespace_table,
			new_item as new_namespace_table
		undefine
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
			l_context_pointer: POINTER; l_encoding_name: STRING; tag_splitter: EL_SPLIT_ON_CHARACTER [STRING]
			section: STRING; end_index, index_xml_ns: INTEGER; is_namespace_aware: BOOLEAN
		do
			make_default
			if parse_failed then
				document_xml := default_xml
				create error_message.make_from_general (last_exception.description)
			else
				document_xml := a_xml
				create error_message.make_empty
				create tag_splitter.make (a_xml, '<')
				-- look for xmlns name in document root element
				across tag_splitter as tag until end_index.to_boolean loop
					section := tag.item
					if section.count > 0 and section [1].is_alpha then
						end_index := section.index_of ('>', 1) - 1
						index_xml_ns := section.substring_index (XMLNS, 1)
						if index_xml_ns > 0 and then section.valid_index (index_xml_ns + XMLNS.count) then
							is_namespace_aware := (" =:").has (section [index_xml_ns + XMLNS.count])
						end
					end
				end
			end

			l_context_pointer := Parser.root_context_pointer (document_xml, is_namespace_aware)

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

	processing_instruction (a_name: STRING): detachable STRING
		-- processing instruction with `a_name' or `Void' if not found
		local
			pi_name_index: INTEGER
		do
			across Current as token until attached Result loop
				if token.is_processing_instruction_name and then token.item_string_8 ~ a_name then
					pi_name_index := token.cursor_index

				elseif token.is_processing_instruction and then pi_name_index = (token.cursor_index - 1) then
					Result := token.item_string_8
				end
			end
		end

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
			s: EL_ZSTRING_ROUTINES; l_result: ZSTRING
		do
			create l_result.make_empty
			across Current as token loop
				if token.is_character_data_item then
					Result := Result + s.word_count (token.item_string, True)

				elseif token.is_attribute_name then
					l_result := token.item_string_8

				elseif token.is_attribute and then included_attributes.has (l_result) then
					Result := Result + s.word_count (token.item_string, True)
				end
			end
		end

feature -- Status query

	namespaces_defined: BOOLEAN
			-- Are any namespaces defined in document
		do
			Result := namespace_table.count > 0
		end

	parse_failed: BOOLEAN

	valid_token_index (index: INTEGER): BOOLEAN
		do
			Result := token_index_lower <= index and index <= token_index_upper
		end

feature {EL_DOCUMENT_TOKEN_ITERATOR} -- Implementation

	default_xml: STRING
		local
			default_doc: EL_DEFAULT_SERIALIZEABLE_XML
		do
			create default_doc
			Result := default_doc.to_xml
		end

	new_namespace_table: HASH_TABLE [STRING, STRING]
		local
			stage, last_token: INTEGER; s: EL_STRING_8_ROUTINES
		do
			create Result.make_equal (3)
			stage := 1
			across Current as token until stage = 3 loop
				inspect stage
					when 1 then -- start element
						stage := stage + token.is_element_open.to_integer

					when 2 then -- root element attributes
						if token.is_attribute_name_space then
							if attached token.item_string_8 as ns_name then
								if ns_name ~ xmlns then
									Result.put (create {STRING}.make_empty, Default_name)
								else
									Result.put (create {STRING}.make_empty, s.substring_to_reversed (ns_name, ':', default_pointer))
								end
							end

						elseif token.is_attribute and last_token = Token_enum.attribute_name_space then
							Result.found_item.share (token.item_string_8)
						end
						stage := stage + token.is_element_close.to_integer
				else
				end
				last_token := token.item
			end
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

	XMLNS: STRING = "xmlns"

	Default_name: STRING = "default"

end