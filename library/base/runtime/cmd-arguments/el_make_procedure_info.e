note
	description: "Abstraction for mapping command line arguments to the arguments of a classes make procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 11:51:30 GMT (Friday 25th January 2019)"
	revision: "1"

deferred class
	EL_MAKE_PROCEDURE_INFO

feature -- Access

	argument_errors: CHAIN [EL_COMMAND_ARGUMENT_ERROR]
		deferred
		end

	operands: TUPLE
		deferred
		end

	extend_help (word_option, description: READABLE_STRING_GENERAL; default_value: ANY)
		deferred
		end

end
