note
	description: "[
		Converts Pyxis format Eiffel project configuration with `.pecf' extension to `.ecf' XML file
	]"
	notes: "[
		**Expansions**

		**1.** Schema and name space expansion
			configuration_ns = "1-16-00"

		**2.** Excluded directores file rule by platform
			platform_list:
				"imp_mswin; imp_unix"

		**3.** Abbreviated platform condition
			condition:
				platform = windows
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-27 7:42:59 GMT (Wednesday 27th July 2022)"
	revision: "7"

class
	PYXIS_ECF_CONVERTER

inherit
	EL_APPLICATION_COMMAND

	EL_PYXIS_TO_XML_CONVERTER
		redefine
			check_output_xml, description, new_output_path, new_xml_generator
		end

create
	make

feature -- Constants

	Description: STRING = "Convert Pyxis format Eiffel project configuration to `.ecf' XML file"

feature {NONE} -- Implementation

	check_output_xml
		local
			ecf_xdoc: EL_XML_DOC_CONTEXT
		do
			create ecf_xdoc.make_from_file (output_path)
			if ecf_xdoc.parse_failed then
				if attached ecf_xdoc.last_exception as exception then
					exception.put_error (lio)
				end
			else
				lio.put_labeled_string ("No errors detected in", output_path.base)
				lio.put_new_line
			end
		end

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