note
	description: "Xml to pyxis converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 12:49:59 GMT (Tuesday 18th February 2020)"
	revision: "6"

class
	XML_TO_PYXIS_CONVERTER

inherit
	EL_XML_TO_PYXIS_CONVERTER
		export
			{EL_COMMAND_CLIENT} make
		end

	EL_FILE_PROCESSING_COMMAND
		rename
			set_file_path as set_source_path
		redefine
			set_source_path
		end

create
	make, make_default

end
