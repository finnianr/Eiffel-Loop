note
	description: "Output routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 9:38:59 GMT (Monday 6th January 2020)"
	revision: "1"

deferred class
	OUTPUT_ROUTINES

inherit
	EL_MODULE_LIO

feature {NONE} -- Implementation

	log_assignment (name: STRING; value: ANY)
		do
			lio.put_labeled_substitution (generator,  "%S := %"%S%"", [name, value])
			lio.put_new_line
		end

	log_extend (name: STRING; list: CHAIN [ANY])
		do
			lio.put_labeled_substitution (generator, "%S.extend (%S)", [name, list.last.generator])
			lio.put_new_line
		end

end
