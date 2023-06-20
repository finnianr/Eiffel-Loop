note
	description: "Secure KEY file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-20 7:34:08 GMT (Tuesday 20th June 2023)"
	revision: "1"

class
	EL_SECURE_KEY_FILE

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		rename
			field_included as is_any_field,
			xml_naming as eiffel_naming
		end

	EL_MODULE_DIRECTORY; EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (target_path: FILE_PATH)
		local
			config_path: FILE_PATH
		do
			config_path := Directory.App_configuration + target_path.base
			config_path.add_extension (Extension.xml)

			secure_path := target_path.twin
			secure_path.add_extension (Extension.secure)
		end

feature -- Basic operations

	lock
		do

		end

	unlock
		do

		end

feature {NONE} -- Internal attributes

	secure_path: FILE_PATH

feature {NONE} -- Constants

	Extension: TUPLE [secure, xml: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "secure, xml")
		end

end