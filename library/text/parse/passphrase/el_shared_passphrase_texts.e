note
	description: "Shared instance of [$source EL_PASSPHRASE_TEXTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-31 10:35:12 GMT (Tuesday 31st August 2021)"
	revision: "1"

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