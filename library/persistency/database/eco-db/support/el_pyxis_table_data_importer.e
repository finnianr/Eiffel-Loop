note
	description: "Table data importer from Pyxis data file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-22 9:55:15 GMT (Tuesday 22nd December 2020)"
	revision: "1"

class
	EL_PYXIS_TABLE_DATA_IMPORTER [G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end]

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS
		export
			{NONE} all
		end

	EL_PYXIS_PARSE_EVENT_TYPE

	EL_COMMAND

	EL_REFLECTION_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_chain: like chain; a_file_path: EL_FILE_PATH)
		local
			xpath_item, xpath_attribute: STRING; l_item: G
		do
			chain := a_chain; file_path := a_file_path
			make_default
			xpath_item := Xpath_template #$ [file_path.base_sans_extension]
			match_events_list.extend ([On_open, xpath_item, agent push_item])
			match_events_list.extend ([On_close, xpath_item, agent pop_item])

			create l_item.make_default
			across l_item.field_table as field loop
				xpath_attribute := Xpath_attribute_template #$ [xpath_item, field.key]
				if attached {EL_REFLECTED_ENUMERATION [NUMERIC]} field.item as enum then
					match_events_list.extend ([On_open, xpath_attribute, agent set_item_enumeration (field.item)])
				elseif attached {EL_REFLECTED_NUMERIC_FIELD [NUMERIC]} field.item as numeric then
					match_events_list.extend ([On_open, xpath_attribute, agent set_item_attribute (field.item)])
				end
			end
		end

	make_default
		do
			create match_events_list.make (20)
			create stack.make (3)
		end

feature -- Basic operations

	execute
		do
			build_from_file (file_path)
		end

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		do
			Result := match_events_list.to_array
		end

	item: EL_REFLECTIVE
		do
			Result := stack.item
		end

	pop_item
		do
			stack.remove
		end

	push_item
		do
			stack.put (create {G}.make_default)
		end

	set_item_attribute (field: EL_REFLECTED_FIELD)
		do
			field.set_from_readable (item, last_node)
		end

	set_item_enumeration (field: EL_REFLECTED_FIELD)
		do
			field.set_from_string (item, last_node.to_raw_string_32)
		end

feature {NONE} -- Internal attributes

	chain: ECD_REFLECTIVE_RECOVERABLE_CHAIN [G]

	match_events_list: ARRAYED_LIST [EL_XPATH_TO_AGENT_MAP]

	file_path: EL_FILE_PATH

	stack: ARRAYED_STACK [EL_REFLECTIVE]

feature {NONE} -- Constants

	Xpath_template: EL_ZSTRING
		once
			Result := "/%S/item"
		end

	Xpath_attribute_template: EL_ZSTRING
		once
			Result := "%S/@%S"
		end

end