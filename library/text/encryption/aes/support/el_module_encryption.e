note
	description: "Access to routines for AES encryption and creating SHA or MD5 digests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-04 7:31:00 GMT (Friday 4th June 2021)"
	revision: "6"

deferred class
	EL_MODULE_ENCRYPTION

inherit
	EL_MODULE

feature {NONE} -- Constants

	Encryption: EL_ENCRYPTION_ROUTINES
		once
			create Result
		end
end