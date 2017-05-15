note
	description: "Summary description for {EL_EIFFEL_CONFIGURATION_FILE_GENERATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-12 12:57:42 GMT (Friday 12th May 2017)"
	revision: "1"

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
