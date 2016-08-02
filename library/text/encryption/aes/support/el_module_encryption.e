note
	description: "Access to routines for AES encryption and creating SHA or MD5 digests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-25 14:55:05 GMT (Monday 25th July 2016)"
	revision: "1"

class
	EL_MODULE_ENCRYPTION

inherit
	EL_MODULE

feature -- Access

	Encryption: EL_ENCRYPTION_ROUTINES
		once
			create Result
		end
end
