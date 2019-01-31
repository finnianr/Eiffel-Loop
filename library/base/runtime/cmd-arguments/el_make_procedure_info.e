note
	description: "Abstraction for mapping command line arguments to the arguments of a make procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 18:03:43 GMT (Friday 25th January 2019)"
	revision: "2"

deferred class
	EL_MAKE_PROCEDURE_INFO

feature -- Access

	extend_errors (error: EL_COMMAND_ARGUMENT_ERROR)
		deferred
		end

	extend_help (word_option, description: READABLE_STRING_GENERAL; default_value: ANY)
		deferred
		end

	operands: TUPLE
		deferred
		end

feature -- Status query

	has_argument_errors: BOOLEAN
		deferred
		end

end
