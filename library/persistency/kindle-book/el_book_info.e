note
	description: "Published book information reflectively settable from XML context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-26 18:40:55 GMT (Friday 26th October 2018)"
	revision: "1"

class
	EL_BOOK_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			xml_element_name as to_kebab_case,
			element_node_type as	Text_element_node
		end

create
	make_default

feature -- Access

	author: ZSTRING

	title: ZSTRING

	publisher: ZSTRING

	uuid: STRING

end
