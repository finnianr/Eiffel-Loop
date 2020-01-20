note
	description: "Remote result from call to remote EROS function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 20:38:02 GMT (Monday 20th January 2020)"
	revision: "1"

class
	EROS_RESULT [G]

inherit
	ANY

	EL_MODULE_LOG

	EL_MODULE_STRING_8

create
	make

feature {NONE} -- Initialization

	make (proxy: EROS_PROXY; routine_name: STRING; argument_tuple: TUPLE)
		do
			proxy.call (routine_name, argument_tuple)
			if not proxy.has_error then
				if attached {EROS_STRING_RESULT} proxy.result_object as l_result then
					log.put_labeled_string (once "Received result", l_result.value)
					log.put_new_line
					if String_8.is_convertible (l_result.value, {G})
						and then attached {G} String_8.to_type (l_result.value, {G}) as value
					then
						item := value
					else
						log.put_labeled_substitution (
							"Error", "Cannot convert %"%S%" to type %S", [l_result.value, ({G}).name]
						)
						log.put_new_line
					end
				elseif attached {G} proxy.result_object as object then
					item := object
					log.put_labeled_string (once "Received result of type", ({G}).name)
					log.put_new_line
				else
					log.put_labeled_string (once "Cannot convert result to type", ({G}).name)
					log.put_new_line
				end
			end
		end

feature -- Access

	item: G

feature {NONE} -- Implementation

	set_default_item
		do
		end

end
