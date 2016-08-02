note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-02 7:26:39 GMT (Saturday 2nd July 2016)"
	revision: "1"

class
	EL_XML_TAG_LIST

inherit
	EL_ZSTRING_LIST
		rename
			make as make_list,
			joined_strings as to_string
		export
			{NONE} all
			{ANY} do_all, count, start, item
		end

	EL_MODULE_XML
		undefine
			copy, is_equal
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
		do
			make_list (5)
			extend (XML.open_tag (tag_name))
			if new_line_after_open_tag then
				last.append_character ('%N')
			end
			extend (XML.closed_tag (tag_name))
			last.append_character ('%N')
		end

	make_from_other (other: EL_XML_TAG_LIST)
			--
		do
			make_list (other.count)
			append (other)
		end

feature -- Element change

	append_tags (tags: EL_XML_TAG_LIST)
			--
		do
			tags.do_all (agent extend)
		end

feature -- Conversion

	to_xml: ZSTRING
			--
		do
			Result := to_string
		end

	to_utf_8_xml: STRING
		do
			Result := to_string.to_utf_8
		end

feature {NONE} -- Implementation

	new_line_after_open_tag: BOOLEAN
			--
		do
		end

end
