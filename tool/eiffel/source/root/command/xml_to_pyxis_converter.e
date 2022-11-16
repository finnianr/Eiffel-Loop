note
	description: "Xml to pyxis converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "8"

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