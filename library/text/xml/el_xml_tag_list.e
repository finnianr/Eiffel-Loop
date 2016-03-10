note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-24 9:02:30 GMT (Friday 24th May 2013)"
	revision: "2"

class
	EL_XML_TAG_LIST

inherit
	LINKED_LIST [STRING]
		rename
			make as make_list
		export
			{NONE} all
			{ANY} do_all, count, start, item
		redefine
			default_create
		end

	EL_MODULE_XML
		export
			{NONE} all
		undefine
			copy, is_equal, default_create
		end

	EL_SERIALIZEABLE_AS_XML
		undefine
			copy, is_equal, default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			make_list
		end

	make (tag_name: STRING)
			--
		do
			make_list
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
			make_list
			other.do_all (agent extend)
		end

feature -- Element change

	append_tags (tags: EL_XML_TAG_LIST)
			--
		do
			tags.do_all (agent extend)
		end

feature -- Conversion

	to_string, to_xml: STRING
			--
		do
			Buffer.clear_all
			do_all (agent append_to_buffer)
			Result := Buffer.string
		end

feature {NONE} -- Implementation

	append_to_buffer (s: STRING)
			--
		do
			Buffer.append_string (s)
		end

	new_line_after_open_tag: BOOLEAN
			--
		do
		end

	Buffer: STRING
			--
		once
			create Result.make (256)
		end

end

