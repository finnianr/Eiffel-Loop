note
	description: "Define the language that is be used for translation item identifiers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-26 18:02:44 GMT (Friday 26th July 2024)"
	revision: "2"

deferred class
	EL_SHARED_KEY_LANGUAGE

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	new_key_language: STRING
		do
			Result := "en"
		end

feature {NONE} -- Constants

	Key_language: STRING
		once ("PROCESS")
			Result := new_key_language
		end
end