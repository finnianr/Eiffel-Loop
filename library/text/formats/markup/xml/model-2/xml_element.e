note
	description: "Xml element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 8:37:30 GMT (Sunday 25th August 2024)"
	revision: "14"

deferred class
	XML_ELEMENT

inherit
	ANY; EL_MODULE_XML

feature -- Access

	name: ZSTRING
		deferred
		end

	to_latin_1 (keep_ref: BOOLEAN): STRING
		do
			Once_medium.set_latin_encoding (1)
			Result := to_encoded (keep_ref)
		end

	to_utf_8 (keep_ref: BOOLEAN): STRING
		do
			Once_medium.set_utf_encoding (8)
			Result := to_encoded (keep_ref)
		end

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		deferred
		end

feature {NONE} -- Implementation

	to_encoded (keep_ref: BOOLEAN): STRING
		local
			medium: like Once_medium
		do
			medium := Once_medium
			medium.wipe_out
			write (medium)
			Result := medium.text
			Result.remove_tail (1)
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Constants

	Once_medium: EL_STRING_8_IO_MEDIUM
		once
			create Result.make (50)
		end

end