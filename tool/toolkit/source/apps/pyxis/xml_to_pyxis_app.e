note
	description: "Xml to pyxis app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "16"

class
	XML_TO_PYXIS_APP

inherit
	EL_COMMAND_LINE_APPLICATION [EL_XML_TO_PYXIS_CONVERTER]
		rename
			command as converter
		redefine
			Option_name, run
		end

	EL_MODULE_OS

create
	make

feature -- Basic operations

	run
		do
			if converter.is_convertable then
				converter.execute
			end
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("in", "Path to XML source file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like converter]
		do
			Result := agent {like converter}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "xml_to_pyxis"

end