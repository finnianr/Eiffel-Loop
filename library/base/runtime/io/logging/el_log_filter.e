note
	description: "Log filter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 11:21:15 GMT (Saturday 3rd December 2022)"
	revision: "18"

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
			create split_list.make_comma_split (routine_list)
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

	print_to (log: EL_LOGGABLE)
		local
			name: STRING; index: INTEGER
		do
			if class_type.type_id /= - 1 then
				log.put_new_line
				log.put_keyword ("class ")
				log.put_classname (class_type.name)
				log.put_character (':')

				log.tab_right; log.put_new_line
				inspect type
					when Show_all then
						log.put_string ("(All routines)")

					when Show_none then
						log.put_string ("(None)")
				else
					across routine_set as set loop
						name := set.item
						if name.count > 0 and then name [1] = '-' then
							log.put_string (name.substring (2, name.count))
							log.put_string (" (Disabled)")
						else
							log.put_string (name)
						end
						index := index + 1
						if index < routine_set.count then
							log.put_new_line
						end
					end
				end
				log.tab_left
			else
				log.put_labeled_string ("No such class", class_type.name)
				log.put_new_line
			end
		end

feature {NONE} -- Constants

	Empty_set: EL_HASH_SET [STRING]
		once
			create Result.make (0)
		end

end