note
	description: "Summary description for {EL_REFLECTIVELY_JSON_SETTABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-04 14:52:38 GMT (Monday 4th December 2017)"
	revision: "2"

deferred class
	EL_REFLECTIVELY_JSON_SETTABLE

inherit
	EL_REFLECTIVELY_SETTABLE [ZSTRING]

	EL_JSON_ROUTINES
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_from_json (string: STRING)
		do
			make_default
			set_from_json (create {EL_JSON_NAME_VALUE_LIST}.make (string))
		end

feature -- Access

	as_json: STRING
		local
			table: like field_index_table; is_first: BOOLEAN
			exported: like Export_tuple
		do
			Result := empty_once_string_8
			exported := Export_tuple
			table := field_index_table
			Result.append (once "{%N")
			from is_first := True; table.start until table.after loop
				if is_first then
					is_first := False
				else
					Result.append (once ",%N")
				end
				exported.name_out.wipe_out
				exported.name_in := table.key_for_iteration
				export_name.call (exported)
				Result.append (once "%T%"")
				Result.append (exported.name_out)
				Result.append (once "%": %"")
				Result.append (encoded (field_item_from_index (table.item_for_iteration)))
				Result.append_character ('"')
				table.forth
			end
			Result.append (once "%N}")
			Result := Result.twin
		end

feature -- Element change

	set_from_json (json_list: EL_JSON_NAME_VALUE_LIST)
		local
			table: like field_index_table; object: like current_object
		do
			object := current_object; table := field_index_table
			from json_list.start until json_list.after loop
				table.search (json_list.name_item_8)
				if table.found then
					set_object_field (object, table.found_item, json_list.value_item)
				end
				json_list.forth
			end
		end

feature {NONE} -- Constants

	Export_tuple: TUPLE [name_in, name_out: STRING]
		once
			Result := ["", ""]
		end

end
