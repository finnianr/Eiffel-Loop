note
	description: "Iterate VTD tokens over an XML document"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 12:28:18 GMT (Monday 23rd September 2024)"
	revision: "7"

class
	EL_DOCUMENT_TOKEN_ITERATOR

inherit
	READABLE_INDEXABLE_ITERATION_CURSOR [INTEGER]
		redefine
			target
		end

	EL_VTD_CONSTANTS

create
	make

feature -- Access

	item_string: ZSTRING
		do
			Result := target.wide_string_at_index (cursor_index)
		end

	item_string_32: STRING_32
		do
			Result := target.wide_string_at_index (cursor_index)
		end

	item_string_8: STRING
		do
			Result := target.wide_string_at_index (cursor_index)
		end

	name: STRING
		do
			if Name_table.has_key (item) then
				Result := Name_table.found_item
			else
				create Result.make_empty
			end
		end

feature -- Status query

	is_attribute: BOOLEAN
		do
			Result := item = Token.attribute_value
		end

	is_attribute_name: BOOLEAN
		do
			Result := item = Token.attribute_name
		end

	is_attribute_name_space: BOOLEAN
		do
			Result := item = Token.attribute_name_space
		end

	is_character_data_item: BOOLEAN
		do
			Result := item = Token.character_data
		end

	is_comment_item: BOOLEAN
		do
			Result := item = Token.comment
		end

	is_declaration_attribute: BOOLEAN
		do
			Result := item = Token.declaration_attribute_value
		end

	is_declaration_attribute_name: BOOLEAN
		do
			Result := item = Token.declaration_attribute_name
		end

	is_document_type_definition: BOOLEAN
		do
			Result := item = Token.dtd_value
		end

	is_element_close: BOOLEAN
		do
			Result := item = Token.ending_tag
		end

	is_element_open: BOOLEAN
		do
			Result := item = Token.starting_tag
		end

	is_name_space: BOOLEAN
		do
			Result := item = Token.attribute_name_space
		end

	is_processing_instruction: BOOLEAN
		do
			Result := item = Token.PI_value
		end

	is_processing_instruction_name: BOOLEAN
		do
			Result := item = Token.PI_name
		end

feature {NONE} -- Internal attributes

	target: EL_XML_DOC_CONTEXT

feature {NONE} -- Constants

	Name_table: EL_HASH_TABLE [STRING, INTEGER]
		once
			Result := <<
				[Token.attribute_name, "attribute_name"],
				[Token.attribute_name_space, "attribute_name_space"],
				[Token.attribute_value, "attribute_value"],
				[Token.character_data, "character_data"],
				[Token.character_data_value, "character_data_value"],
				[Token.comment, "comment"],
				[Token.declaration_attribute_name, "declaration_attribute_name"],
				[Token.declaration_attribute_value, "declaration_attribute_value"],
				[Token.document, "document"],
				[Token.dtd_value, "dtd_value"],
				[Token.ending_tag, "ending_tag"],
				[Token.pi_name, "pi_name"],
				[Token.pi_value, "pi_value"],
				[Token.starting_tag, "starting_tag"]
			>>
		end
end