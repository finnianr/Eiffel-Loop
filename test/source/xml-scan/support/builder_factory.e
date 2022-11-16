note
	description: "Builder factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	BUILDER_FACTORY

create
	make

feature {NONE} -- Initialization

	make
		do
			create {EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER} smart_builder.make
		end

feature -- Factory

	new_matrix (file_path: FILE_PATH): MATRIX_CALCULATOR
			--
		do
			create Result.make_from_file (file_path)
		end

	new_serializeable (file_path: FILE_PATH): EL_BUILDABLE_FROM_NODE_SCAN
		-- detect type from processing instruction
		do
			smart_builder.build_from_file (file_path)
			if smart_builder.has_item then
				Result := smart_builder.item
			end
		end

	new_smil_presentation (file_path: FILE_PATH): SMIL_PRESENTATION
			--
		do
			create Result.make_from_file (file_path)
		end

	new_web_form (file_path: FILE_PATH): WEB_FORM
			--
		do
			create Result.make_from_file (file_path)
		end

feature {NONE} -- Internal attributes

	smart_builder: EL_SMART_BUILDABLE_FROM_NODE_SCAN
end