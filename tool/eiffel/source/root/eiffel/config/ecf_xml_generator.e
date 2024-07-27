note
	description: "ECF XML generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-25 19:11:45 GMT (Thursday 25th July 2024)"
	revision: "5"

class
	ECF_XML_GENERATOR

inherit
	EL_PYXIS_XML_TEXT_GENERATOR
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_type ({PYXIS_ECF_PARSER})
		end
end