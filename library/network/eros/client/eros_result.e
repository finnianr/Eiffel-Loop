note
	description: "Remote result from call to remote EROS function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-11 9:02:53 GMT (Saturday 11th November 2023)"
	revision: "5"

class
	EROS_RESULT [G]

inherit
	ANY

	EL_MODULE_CONVERT_STRING

create
	make_call

convert
	item: {G}

feature {NONE} -- Initialization

	make_call (proxy: EROS_PROXY; routine_name: STRING; argument_tuple: TUPLE)
		-- make result `item' by calling remote `routine_name' with `argument_tuple'
		local
			log: EL_LOGGABLE
		do
			proxy.call (routine_name, argument_tuple)
			log := proxy.log
			if not proxy.has_error then
				if attached {EROS_STRING_RESULT} proxy.result_object as l_result then
					log.put_labeled_string (once "Received result", l_result.value)
					log.put_new_line

					if Convert_string.is_convertible (l_result.value, {G})
						and then attached {G} Convert_string.to_type (l_result.value, {G}) as value
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