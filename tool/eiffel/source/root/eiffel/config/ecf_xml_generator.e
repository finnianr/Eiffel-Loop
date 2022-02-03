note
	description: "ECF XML generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 12:50:58 GMT (Thursday 3rd February 2022)"
	revision: "3"

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
			make_generator ({PYXIS_ECF_PARSER})
		end
end