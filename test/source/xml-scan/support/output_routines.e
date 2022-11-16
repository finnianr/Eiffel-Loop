note
	description: "Output routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

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