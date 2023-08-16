note
	description: "XML element attribute node string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 9:14:26 GMT (Thursday 27th July 2023)"
	revision: "12"

class
	EL_ELEMENT_ATTRIBUTE_NODE_STRING

inherit
	EL_DOCUMENT_NODE_STRING
		export
			{NONE} set_type
		redefine
			extend_xpath, make
		end

create
	make

feature {NONE} -- Initialization

	make (a_document_dir: DIR_PATH)
			--
		do
			Precursor (a_document_dir)
			type := Type_attribute
		end

feature -- Basic operations

	extend_xpath (xpath: STRING)
			--
		do
			xpath.append_character ('@')
			xpath.append (raw_name)
		end

end