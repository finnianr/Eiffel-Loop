note
	description: "Access to routines for AES encryption and creating SHA or MD5 digests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "3"

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
