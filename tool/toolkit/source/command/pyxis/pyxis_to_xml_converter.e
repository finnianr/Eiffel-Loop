note
	description: "Pyxis to xml converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 12:52:47 GMT (Saturday 11th January 2020)"
	revision: "13"

class
	PYXIS_TO_XML_CONVERTER

inherit
	EL_PYXIS_TO_XML_CONVERTER
		redefine
			new_output_path, new_xml_generator
		end

create
	make

feature {NONE} -- Implementation

	new_output_path: EL_FILE_PATH
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

	Pecf: ZSTRING
		once
			Result := "pecf"
		end
end
