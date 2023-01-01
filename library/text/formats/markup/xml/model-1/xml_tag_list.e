note
	description: "Xml tag list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 17:33:58 GMT (Sunday 1st January 2023)"
	revision: "11"

class
	XML_TAG_LIST

inherit
	EL_ZSTRING_LIST
		rename
			make as make_sized,
			joined_strings as to_string
		export
			{NONE} all
			{ANY} do_all, count, start, item
		end

	EL_SERIALIZEABLE_AS_XML
		undefine
			copy, is_equal
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (tag_name: STRING)
			--
		local
			XML: XML_ROUTINES
		do
			make_sized (5)
			extend (XML.open_tag (tag_name))
			if new_line_after_open_tag then
				last.append_character ('%N')
			end
			extend (XML.closed_tag (tag_name))
			last.append_character ('%N')
		end

	make_from_other (other: XML_TAG_LIST)
			--
		do
			make_sized (other.count)
			append (other)
		end

feature -- Element change

	append_tags (tags: XML_TAG_LIST)
			--
		do
			tags.do_all (agent extend)
		end

feature -- Conversion

	to_xml: STRING
		do
			Result := to_string.to_utf_8 (True)
		end

feature {NONE} -- Implementation

	new_line_after_open_tag: BOOLEAN
			--
		do
		end

end