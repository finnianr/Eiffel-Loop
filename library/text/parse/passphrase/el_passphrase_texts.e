note
	description: "Localization texts for passphrase rating"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-01 17:53:20 GMT (Tuesday 1st March 2022)"
	revision: "4"

class
	EL_PASSPHRASE_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS

create
	make

feature -- Templates

	minimum_score: ZSTRING

	passphrase_strength: ZSTRING

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
			]"
		end

end