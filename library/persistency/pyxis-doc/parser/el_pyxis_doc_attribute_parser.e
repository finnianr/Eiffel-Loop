note
	description: "Pyxis document line attribute parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-03 8:59:36 GMT (Thursday 3rd November 2022)"
	revision: "1"

class
	EL_PYXIS_DOC_ATTRIBUTE_PARSER

inherit
	EL_PYXIS_ATTRIBUTE_PARSER
		redefine
			source_text
		end

	EL_DOCUMENT_CLIENT

create
	make

feature {NONE} -- Initialization

	make (a_attribute_list: like attribute_list)
		do
			attribute_list := a_attribute_list
			make_default
		end

feature {NONE} -- Title parsing actions

	on_name (start_index, end_index: INTEGER)
			--
		local
			s: EL_STRING_8_ROUTINES
		do
			attribute_list.extend
			if attached attribute_list.last.raw_name as name then
				name.wipe_out
				name.append_substring (source_text, start_index, end_index)
				s.replace_character (name, '.', ':')
			end
		end

	on_quoted_value (content: STRING_GENERAL)
			--
		do
			if attached {like source_text} content as l_content then
				if attached attribute_list.last as last_attribute then
					last_attribute.wipe_out
					last_attribute.append (l_content)
				end
			end
		end

	on_value (start_index, end_index: INTEGER)
			--
		do
			attribute_list.last.wipe_out
			attribute_list.last.append_substring (source_text, start_index, end_index)
		end

feature {NONE} -- Internal attributes

	attribute_list: EL_ELEMENT_ATTRIBUTE_LIST

	source_text: STRING_8
end