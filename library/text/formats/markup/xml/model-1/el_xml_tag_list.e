note
	description: "Xml tag list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-23 10:57:05 GMT (Monday 23rd November 2020)"
	revision: "6"

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

	EL_SERIALIZEABLE_AS_XML
		undefine
			copy, is_equal
		end

	EL_MODULE_XML

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

	to_xml: STRING
		do
			Result := to_string.to_utf_8
		end

feature {NONE} -- Implementation

	new_line_after_open_tag: BOOLEAN
			--
		do
		end

end