note
	description: "Access to routines for AES encryption and creating SHA or MD5 digests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:55:07 GMT (Monday 1st July 2019)"
	revision: "5"

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
