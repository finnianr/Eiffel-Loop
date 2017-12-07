note
	description: "Authorization header for authentication"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 10:21:14 GMT (Wednesday 6th December 2017)"
	revision: "3"

class
	AIA_AUTHORIZATION_HEADER

inherit
	EL_REFLECTIVELY_SETTABLE [STRING]
		rename
			make_default as make
		redefine
			new_default_values, import_name
		end

	EL_SHARED_ONCE_STRINGS
		undefine
			is_equal
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

	EL_MODULE_DIGEST
		undefine
			is_equal
		end

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
			fields.do_all (agent set_field_from_nvp (?, once "="))
		end

	make_signed (signer: AIA_SIGNER; canonical_request: AIA_CANONICAL_REQUEST)
		-- make signed header
		local
			hmac: EL_HMAC_SHA_256; string_to_sign, header_list: EL_STRING_LIST [STRING]
		do
			make
			algorithm := Default_algorithm
			create header_list.make_from_array (canonical_request.sorted_header_list.key_list.to_array)
			signed_headers := header_list.joined (Semicolon [1])

			create string_to_sign.make_from_array (<<
				algorithm, signer.iso8601_time, Empty_string_8,
				canonical_request.sha_256_digest.to_hex_string
			>>)

			create hmac.make (signer.credential.daily_secret (signer.short_date))
			hmac.sink_string (string_to_sign.joined_lines)
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
			create Result.make (signed_headers, Semicolon)
		end

feature {NONE} -- Implementation

	import_name: like Default_import_name
		do
			Result := agent from_camel_case
		end

	new_default_values: EL_ARRAYED_LIST [ANY]
		do
			Result := Precursor + create {AIA_CREDENTIAL_ID}.make_default
		end

feature {NONE} -- Constants

	Algorithm_equals: STRING = "algorithm="

	Default_algorithm: STRING_8
		once
			Result := "DTA1-HMAC-SHA256"
		end

	Semicolon: ZSTRING
		once
			Result := ";"
		end

	Signed_string_template: EL_SUBSTITUTION_TEMPLATE [STRING]
		once
			create Result.make ("$algorithm SignedHeaders=$signed_headers, Credential=$key/$date, Signature=$signature")
		end
end
