note
	description: "Module x509 command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_MODULE_X509_COMMAND

inherit
	EL_MODULE

feature {NONE} -- Constants

	X509_command: EL_X509_COMMAND_FACTORY
		once
			create Result
		end

end