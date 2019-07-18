note
	description: "Authorization header for authentication"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:46:52 GMT (Monday 1st July 2019)"
	revision: "10"

class
	AIA_AUTHORIZATION_HEADER

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as to_camel_case,
			import_name as from_camel_case,
			make_default as make
		end

	EL_SETTABLE_FROM_STRING_8
		rename
			make_default as make
		end

	EL_STRING_8_CONSTANTS
		undefine
			is_equal
		end

	EL_MODULE_DIGEST

	EL_SHARED_ONCE_STRINGS

create
	make, make_from_string, make_signed

feature {NONE} -- Initialization

	make_from_string (str: STRING)
		local
			modified: STRING; fields: EL_SPLIT_STRING_LIST [STRING]
		do
			make
			modified := empty_once_string_8
			-- Tweak `str' to make it splittable as series of assignments
			modified.append (Algorithm_equals); modified.append (str)
			modified.insert_character (',', modified.index_of (' ', Algorithm_equals.count))
			create fields.make (modified, once ",")
			fields.enable_left_adjust
			fields.do_all (agent set_field_from_nvp (?, '='))
		end

	make_signed (signer: AIA_SIGNER; canonical_request: AIA_CANONICAL_REQUEST)
		-- make signed header
		local
			hmac: EL_HMAC_SHA_256; string_list: EL_STRING_LIST [STRING]
		do
			make
			algorithm := Default_algorithm
			signed_headers := canonical_request.sorted_header_names.joined (Semicolon)

			create string_list.make_from_array (<<
				algorithm, signer.iso8601_time, Empty_string_8,
				canonical_request.sha_256_digest.to_hex_string
			>>)

			create hmac.make (signer.credential.daily_secret (signer.short_date))
			hmac.sink_joined_strings (string_list, '%N')
			hmac.finish
			signature := hmac.digest.to_hex_string
			credential.set_key (signer.credential.public)
			credential.set_date (signer.short_date)
		end

feature -- Access

	algorithm: STRING

	as_string: STRING
		local
			template: like Signed_string_template
		do
			template := Signed_string_template
			template.wipe_out_variables
			template.set_variables_from_object (Current)
			template.set_variables_from_object (credential)
			Result := template.substituted
		end

	credential: AIA_CREDENTIAL_ID

	signature: STRING

	signed_headers: STRING

	signed_headers_list: EL_SPLIT_STRING_LIST [STRING]
		do
			create Result.make (signed_headers, Semicolon_string)
		end

feature {NONE} -- Constants

	Algorithm_equals: STRING = "algorithm="

	Default_algorithm: STRING_8
		once
			Result := "DTA1-HMAC-SHA256"
		end

	Semicolon: CHARACTER_32 = ';'

	Semicolon_string: ZSTRING
		once
			create Result.make_filled (Semicolon, 1)
		end

	Signed_string_template: EL_STRING_8_TEMPLATE
		once
			create Result.make ("$algorithm SignedHeaders=$signed_headers, Credential=$key/$date, Signature=$signature")
		end
end
