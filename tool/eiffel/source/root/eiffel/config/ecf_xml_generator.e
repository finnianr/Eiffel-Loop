note
	description: "ECF XML generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "2"

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
