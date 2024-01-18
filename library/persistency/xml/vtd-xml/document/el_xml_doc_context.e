note
	description: "Top level ${EL_XPATH_NODE_CONTEXT} object representing an XML document"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-11 14:49:56 GMT (Thursday 11th January 2024)"
	revision: "29"

class
	EL_XML_DOC_CONTEXT

inherit
	EL_XPATH_NODE_CONTEXT
		rename
			make as make_context,
			Token as Token_enum
		export
			{ANY} Html
		undefine
			namespace_table
		end

	EL_LAZY_ATTRIBUTE
		rename
			item as namespace_table,
			new_item as new_namespace_table
		end

	READABLE_INDEXABLE [INTEGER]
		rename
			item as token_type,
			lower as token_index_lower,
			upper as token_index_upper,
			valid_index as valid_token_index
		redefine
			new_cursor
		end

	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		redefine
			make_default
		end

	EL_CHARACTER_8_CONSTANTS

create
	make_from_file, make_from_string, make_from_fragment, make_from_xhtml

convert
	make_from_file ({FILE_PATH})

feature {NONE} -- Initialization

	make (a_xml_data: EL_STRING_8_POINTER)
			--
		local
			p_root_context: POINTER; type: STRING
		do
			make_default

			if parse_failed then
				data := Default_xml_data
				if attached {EL_VTD_EXCEPTION} Exception.last_exception as last then
					last_exception := last
				end
				is_namespace_aware := False
			else
				data := a_xml_data
			end
			p_root_context := Parser.new_root_context (data, is_namespace_aware)

			if is_attached (p_root_context) then
				make_context (p_root_context, Current)
				create type.make_from_c (c_node_context_encoding_type (p_root_context))
				set_encoding_from_name (hyphen.joined (type, c_node_context_encoding (p_root_context).out))
			end
		rescue
			parse_failed := True
			retry
		end

	make_default
		do
			Precursor
			data := Default_xml_data
			create file_path
		end

	make_from_file (a_file_path: FILE_PATH)
			--
		do
			make_default
			is_namespace_aware := XML.is_namespace_aware_file (a_file_path)
			make (File.raw_plain_text (a_file_path))
			file_path.share (a_file_path)
		end

	make_from_fragment (xml_fragment: READABLE_STRING_8; a_encoding: STRING)
		do
			make_from_string (new_line.joined (XML.header (1.0, a_encoding).to_latin_1, xml_fragment))
		end

	make_from_string (a_xml: READABLE_STRING_8)
		do
			is_namespace_aware := XML.is_namespace_aware (a_xml)
			make (create {EL_STRING_8_POINTER}.make (a_xml))
		end

	make_from_xhtml (xhtml: READABLE_STRING_8)
		do
			make_from_string (HTML.to_xml (xhtml))
		end

feature -- Basic operations

	store_as (a_file_path: like file_path)
			--
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_write (a_file_path)
			l_file.put_managed_pointer (data, 0, data.count)
			l_file.close
		end

feature -- Token access

	new_cursor: EL_DOCUMENT_TOKEN_ITERATOR
		do
			create Result.make (Current)
			Result.start
		end

	token_string (index: INTEGER): ZSTRING
			--
		do
			Result := wide_string_at_index (index)
		end

	token_string_32 (index: INTEGER): STRING_32
			--
		do
			Result := wide_string_at_index (index)
		end

	token_string_8 (index: INTEGER): STRING
			--
		do
			Result := wide_string_at_index (index)
		end

	token_type (index: INTEGER): INTEGER
		-- alias []
		do
			Result := c_evx_get_token_type (self_ptr, index - 1)
		end

feature -- Access

	data: EL_STRING_8_POINTER
		-- XML character data

	file_path: FILE_PATH

	last_exception: detachable EL_VTD_EXCEPTION

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

	token_depth (index: INTEGER): INTEGER
			--
		require
			valid_index: index >= 1 and index <= token_index_upper
		do
			Result := c_evx_get_token_depth (self_ptr, index - 1)
		end

	token_index_lower: INTEGER
		do
			Result := 1
		end

	token_index_upper: INTEGER
			--
		do
			Result := c_evx_get_token_count (self_ptr)
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

	is_namespace_aware: BOOLEAN

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
								if ns_name ~ XML.xmlns then
									Result.put (create {STRING}.make_empty, Default_name)
								else
									Result.put (create {STRING}.make_empty, s.substring_to_reversed (ns_name, ':'))
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

	Default_name: STRING = "default"

	Default_xml_data: EL_STRING_8_POINTER
		once
			Result := XML.Default_doc.to_xml
		end

	Parser: EL_VTD_XML_PARSER
			--
		once
			create Result.make
		end

end