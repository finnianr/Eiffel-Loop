note
	description: "Xml to pyxis converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	XML_TO_PYXIS_CONVERTER

inherit
	EL_XML_TO_PYXIS_CONVERTER
		export
			{EL_COMMAND_CLIENT} make
		undefine
			new_lio
		redefine
			execute
		end

	EL_COMMAND

	EL_MODULE_LOG

create
	make

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			Precursor
			log.exit
		end

end
