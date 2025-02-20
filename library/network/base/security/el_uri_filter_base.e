note
	description: "Implementaiton base for ${EL_URI_FILTER_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-20 12:31:25 GMT (Thursday 20th February 2025)"
	revision: "3"

deferred class
	EL_URI_FILTER_BASE

inherit
	EL_MODULE_FILE

	EL_URI_FILTER_CONSTANTS

	EL_STRING_8_CONSTANTS

feature -- Access

	maximum_uri_digits: INTEGER
		-- maximum number of digits expected in uri. Any more considered a hacking attempt.

feature -- Element change

	set_maximum_uri_digits (a_maximum_uri_digits: INTEGER)
		do
			maximum_uri_digits := a_maximum_uri_digits
		end

feature -- Factory

	new_match_manifest (predicate_name: STRING): STRING
		do
			if attached (match_output_dir + File_match_text #$ [predicate_name]) as path then
				if path.exists and then attached File.plain_text (path) as text then
					text.right_adjust
					Result := text
				else
					create Result.make_empty
				end
			end
		end

feature {NONE} -- Implementation

	digit_count (path_lower: STRING): INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > path_lower.count loop
				if path_lower [i].is_digit then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	digit_count_exceeded (path_lower: STRING): BOOLEAN
		-- filter requests like: "GET /87543bde9176626b120898f9141058 HTTP/1.1"
		-- but allow: "GET /images/favicon/196x196.png HTTP/1.1"
		do
			if digit_count (path_lower) > maximum_uri_digits and then not is_digit_count_exception (path_lower) then
				Result := True
			end
		end

	dot_extension (path_lower: STRING): STRING
		local
			dot_index: INTEGER
		do
			dot_index := path_lower.last_index_of ('.', path_lower.count)
			if dot_index > 1 then
				Result := path_lower.substring (dot_index + 1, path_lower.count)
			else
				Result := Empty_string_8
			end
		end

	is_digit_count_exception (path_lower: STRING): BOOLEAN
		do
			Result := Image_file_extensions.has (dot_extension (path_lower))
							or else path_lower.starts_with (PKI_validation)
		end

feature {NONE} -- Deferred

	match_output_dir: DIR_PATH
		-- location of "match-*.txt" files for use in EL_URI_FILTER_TABLE
		deferred
		end

feature {NONE} -- Constants

	Image_file_extensions: EL_STRING_8_LIST
		once
			Result := "jpg, jpeg, png"
		end

	PKI_validation: STRING
		once
			Result := ".well-known/pki-validation"
		end

end