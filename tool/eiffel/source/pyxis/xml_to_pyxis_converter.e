note
	description: "Summary description for {XML_TO_PYXIS_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 10:28:11 GMT (Monday 16th October 2017)"
	revision: "2"

class
	XML_TO_PYXIS_CONVERTER

inherit
	EL_XML_TO_PYXIS_CONVERTER
		export
			{EL_COMMAND_LINE_SUB_APPLICATION} make
		undefine
			new_lio
		redefine
			execute
		end

	EL_FILE_PROCESSING_COMMAND
		rename
			set_file_path as set_source_path
		redefine
			set_source_path
		end

	EL_MODULE_LOG

create
	make, make_default

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			Precursor
			log.exit
		end
end
