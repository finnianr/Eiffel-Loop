note
	description: "ECF XML generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

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