note
	description: "Summary description for {DOCUMENT_CONTEXT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	DOCUMENT_CONTEXT

inherit
	EVOLICITY_CONTEXT_IMPL
		rename
			make as make_context
		end

	EL_MODULE_FILE

	EL_MODULE_STRING

	EL_MODULE_LOG

create
	make

feature {NONE} -- Implementation

	make (file_path: FILE_NAME; variables: like objects; content_indent: INTEGER)
			--
		local
			content: STRING
		do
			log.enter ("make")
			make_context
			objects.merge (variables)
			text := File.plain_text (file_path)

			content := find_element_content ("body")
			content.left_adjust
			content.right_adjust
			content := String.indented_text (content, content_indent)

			objects ["content"] := content
			objects ["title"] := find_element_content ("title")

			log.exit
		end

feature -- Access

	text: STRING

feature {NONE} -- Implementation: routines

	find_element_content (element_name: STRING): STRING
			--
		local
			open_tag_pos, close_tag_pos: INTEGER
			open_tag, close_tag: STRING
		do
			create open_tag.make_from_string ("<")
			open_tag.append (element_name)

			create close_tag.make_from_string ("</")
			close_tag.append (element_name)
			close_tag.append_character ('>')

			open_tag_pos := text.substring_index (open_tag, 1)
			close_tag_pos := text.substring_index (close_tag, open_tag_pos + open_tag.count)
			Result := text.substring (open_tag_pos + open_tag.count, close_tag_pos - 1)
			Result.remove_head (Result.index_of ('>', 1))
		end

end
