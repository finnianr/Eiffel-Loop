note
	description: "[
		Shared ${FUNCTION} to create Pyxis source for adhoc-translations.
		Useful for decrypted credit titles for application "about dialog".
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-28 9:38:54 GMT (Wednesday 28th June 2023)"
	revision: "1"

deferred class
	EL_SHARED_ADHOC_TRANSLATIONS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Adhoc_translation_source_factory: CELL [FUNCTION [STRING]]
		once ("PROCESS")
			create Result.put (Void)
		end
end