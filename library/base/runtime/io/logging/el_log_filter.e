note
	description: "Log filter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-27 8:21:30 GMT (Saturday 27th March 2021)"
	revision: "14"

class
	EL_LOG_FILTER

inherit
	ANY

	EL_LOG_CONSTANTS

create
	make, make_selected

feature {NONE} -- Initialization

	make (a_class_type: like class_type; a_type: NATURAL_8)
		do
			class_type := a_class_type; type := a_type
			routine_set := Empty_set
		end

	make_selected (a_class_type: like class_type; routine_list: STRING)
		local
			split_list: EL_STRING_8_LIST
		do
			make (a_class_type, Show_selected)
			create split_list.make_with_csv (routine_list)
			across split_list as list loop
				routine_set.put (list.item)
			end
		ensure
			valid_selected: routine_set.count > 0
		end

feature -- Access

	class_type: TYPE [EL_MODULE_LIO]

	routine_set: EL_HASH_SET [STRING]
		-- set of selected routines (when `type' = `Show_selected')

	type: NATURAL_8
		-- filter type

feature -- Basic operations

	print_to (output: EL_CONSOLE_LOG_OUTPUT)
		local
			name: STRING
		do
			if class_type.type_id /= - 1 then
				output.put_new_line
				output.put_keyword ("class ")
				output.put_classname (class_type.name)
				output.put_character (':')

				output.tab_right; output.put_new_line
				inspect type
					when Show_all then
						output.put_string ("(All routines)")

					when Show_none then
						output.put_string ("(None)")
				else
					across routine_set as set loop
						name := set.item
						if name.count > 0 and then name [1] = '-' then
							output.put_string (name.substring (2, name.count))
							output.put_string (" (Disabled)")
						else
							output.put_string (name)
						end
						if not set.is_last then
							output.put_new_line
						end
					end
				end
				output.tab_left
			else
				output.put_label ("No such class")
				output.put_classname (class_type.name)
				output.put_new_line
			end
		end

feature {NONE} -- Constants

	Empty_set: EL_HASH_SET [STRING]
		once
			create Result.make (0)
		end

end