note
	description: "Shared instance of [$source EL_PASSPHRASE_TEXTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-18 11:48:49 GMT (Monday 18th December 2023)"
	revision: "4"

deferred class
	EL_SHARED_PASSPHRASE_TEXTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Text: EL_PASSPHRASE_TEXTS
		once
			create Result.make
		end
end