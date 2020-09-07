note
	description: "Shared instance of [$source EL_PASSWORD_ATTRIBUTES_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-06 12:30:30 GMT (Sunday 6th September 2020)"
	revision: "1"

deferred class
	EL_SHARED_PASSPHRASE_ATTRIBUTE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Passphrase_attribute: EL_PASSPHRASE_ATTRIBUTES_ENUM
		once
			create Result.make
		end

end
