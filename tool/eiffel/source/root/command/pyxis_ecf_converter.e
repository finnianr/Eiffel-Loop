note
	description: "[
		Converts Pyxis format Eiffel project configuration with `.pecf' extension to `.ecf' XML file
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 12:59:00 GMT (Thursday 13th January 2022)"
	revision: "4"

class
	PYXIS_ECF_CONVERTER

inherit
	EL_PYXIS_TO_XML_CONVERTER
		redefine
			description, new_output_path, new_xml_generator
		end

create
	make

feature -- Constants

	Description: STRING = "Convert Pyxis format Eiffel project configuration to `.ecf' XML file"

feature {NONE} -- Implementation

	new_output_path: FILE_PATH
		do
			if source_path.has_extension (Pecf) then
				Result := source_path.with_new_extension ("ecf")
			else
				Result := Precursor
			end
		end

	new_xml_generator: EL_PYXIS_XML_TEXT_GENERATOR
		do
			if source_path.has_extension (Pecf) then
				create {ECF_XML_GENERATOR} Result.make
			else
				create Result.make
			end
		end

feature {NONE} -- Constants

	Pecf: STRING = "pecf"
end