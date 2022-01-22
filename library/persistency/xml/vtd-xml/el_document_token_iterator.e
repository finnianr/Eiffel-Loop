note
	description: "Iterate VTD tokens over an XML document"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-22 11:40:21 GMT (Saturday 22nd January 2022)"
	revision: "1"

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

feature -- Status query

	is_attribute_name_item: BOOLEAN
		do
			Result := item = Token.attribute_name
		end

	is_attribute_value_item: BOOLEAN
		do
			Result := item = Token.attribute_value
		end

	is_character_data_item: BOOLEAN
		do
			Result := item = Token.character_data
		end

	is_comment_item: BOOLEAN
		do
			Result := item = Token.comment
		end

	is_processing_instruction_name_item: BOOLEAN
		do
			Result := item = Token.PI_name
		end

	is_processing_instruction_value_item: BOOLEAN
		do
			Result := item = Token.PI_value
		end

feature {NONE} -- Internal attributes

	target: EL_XPATH_ROOT_NODE_CONTEXT
end