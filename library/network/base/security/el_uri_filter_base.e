note
	description: "Implementaiton base for ${EL_URI_FILTER_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-08 15:28:11 GMT (Saturday 8th February 2025)"
	revision: "1"

deferred class
	EL_URI_FILTER_BASE

inherit
	EL_ZSTRING_CONSTANTS

feature -- Access

	maximum_uri_digits: INTEGER
		-- maximum number of digits allowed in path

feature -- Element change

	set_maximum_uri_digits (a_maximum_uri_digits: INTEGER)
		do
			maximum_uri_digits := a_maximum_uri_digits
		end

feature {NONE} -- Implementation

	dot_extension (path_lower: ZSTRING): ZSTRING
		local
			dot_index: INTEGER
		do
			dot_index := path_lower.last_index_of ('.', path_lower.count)
			if dot_index > 1 then
				Result := path_lower.substring_end (dot_index + 1)
			else
				Result := Empty_string
			end
		end

	digit_count (path_lower: ZSTRING): INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > path_lower.count loop
				if path_lower.is_numeric_item (i) then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	digit_count_exceeded (path_lower: ZSTRING): BOOLEAN
		-- filter requests like: "GET /87543bde9176626b120898f9141058 HTTP/1.1"
		-- but allow: "GET /images/favicon/196x196.png HTTP/1.1"
		do
			if digit_count (path_lower) > maximum_uri_digits and then not is_digit_count_exception (path_lower) then
				Result := True
			end
		end

	is_digit_count_exception (path_lower: ZSTRING): BOOLEAN
		do
			Result := Image_file_extensions.has (dot_extension (path_lower))
				or else path_lower.starts_with (PKI_validation)
		end

feature {NONE} -- Constants

	Image_file_extensions: EL_ZSTRING_LIST
		once
			Result := "jpg, jpeg, png"
		end

	PKI_validation: ZSTRING
		once
			Result := ".well-known/pki-validation"
		end

end