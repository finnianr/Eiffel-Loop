note
	description: "Localization texts for passphrase rating"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-18 8:11:35 GMT (Monday 18th December 2023)"
	revision: "7"

class
	EL_PASSPHRASE_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS

create
	make

feature -- Templates

	minimum_score: ZSTRING

	passphrase_strength: ZSTRING

	secure_file_prompt: ZSTRING

feature -- Phrases

	confirm_passphrase: ZSTRING

	enter_passphrase: ZSTRING

	incorrect_passphrase: ZSTRING

	make_visible: ZSTRING

	passphrases_are_different: ZSTRING

	passphrase_is_invalid: ZSTRING

	passphrases_match: ZSTRING

feature {NONE} -- Implementation

	english_table: STRING
		do
			Result := "[
				incorrect_passphrase:
					Incorrect passphrase, try again.
				minimum_score:
					(Minimum to continue is %S)
				passphrase_strength:
					Passphrase strength (%S / 6)
				secure_file_prompt:
					Enter a passphrase to secure file "%S"
			]"
		end

end