note
	description: "Module x509 command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

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