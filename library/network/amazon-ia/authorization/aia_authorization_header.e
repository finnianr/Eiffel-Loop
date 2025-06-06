note
	description: "Authorization header for authentication"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 12:03:27 GMT (Friday 21st March 2025)"
	revision: "30"

class
	AIA_AUTHORIZATION_HEADER

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as Camel_case_title,
			make_default as make
		redefine
			Camel_case_title
		end

	EL_SETTABLE_FROM_STRING_8
		rename
			make_default as make
		end

	EL_MODULE_DIGEST

	EL_STRING_8_CONSTANTS

create
	make, make_from_string, make_signed

feature {NONE} -- Initialization

	make_from_string (str: STRING)
		local
			modified_name_list: EL_STRING_8_LIST
		do
			make
			if attached Buffer.copied (Algorithm_equals) as modified then
				-- Tweak `str' to make it splittable as series of assignments
				modified.append (str)
				modified.insert_character (',', modified.index_of (' ', Algorithm_equals.count))

				create modified_name_list.make_adjusted_split (modified, ',', {EL_SIDE}.Left)
				modified_name_list.do_all (agent set_field_from_nvp (?, '='))
			end
		end

	make_signed (signer: AIA_SIGNER; canonical_request: AIA_CANONICAL_REQUEST)
		-- make signed header

		-- PHP: Amazon/InstantAccess/Signature/Signer.php
		-- // We don't use scope in this algorithm
		-- $scope = '';
		-- $stringToSign = self::ALGORITHM_ID . "\n" . $isoDate . "\n" . $scope . "\n" . hash('sha256', $canonicalRequest);
		-- $signature = hash_hmac('sha256', $stringToSign, $timedKey);
		local
			hmac: EL_HMAC_SHA_256
		do
			make
			algorithm := Default_algorithm
			signed_headers := canonical_request.sorted_header_names.joined (Semicolon)

			create hmac.make (signer.credential.daily_secret (signer.short_date))
			hmac.sink_joined_strings (<<
				algorithm, signer.iso8601_time, Empty_string_8, canonical_request.sha_256_digest.to_hex_string
			>>, '%N')
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
			template.set_empty_variables

			template.put_fields (Current)
			template.put_fields (credential)
			Result := template.substituted
		end

	credential: AIA_CREDENTIAL_ID

	signature: STRING

	signed_headers: STRING

	signed_headers_list: EL_STRING_8_LIST
		do
			create Result.make_split (signed_headers, Semicolon)
		end

feature {NONE} -- Implementation

	camel_case_title: EL_NAME_TRANSLATER
		do
			Result := camel_case_translater ({EL_CASE}.Proper)
		end

feature {NONE} -- Constants

	Algorithm_equals: STRING = "algorithm="

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

	Default_algorithm: STRING_8
		once
			Result := "DTA1-HMAC-SHA256"
		end

	Semicolon: CHARACTER = ';'

	Signed_string_template: EL_STRING_8_TEMPLATE
		once
			create Result.make ("$algorithm SignedHeaders=$signed_headers, Credential=$key/$date, Signature=$signature")
		end
end