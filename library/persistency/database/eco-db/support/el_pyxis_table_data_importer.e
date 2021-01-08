note
	description: "Table data importer from Pyxis data file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 14:55:24 GMT (Friday 8th January 2021)"
	revision: "5"

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
			xpath_item: STRING
		do
			chain := a_chain; file_path := a_file_path
			make_default
			xpath_item := Slash + file_path.base_sans_extension.to_latin_1 + Slash_item
			fill_match_events (create {G}.make_default, xpath_item, "")
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
		ensure then
			empty_stack: stack.is_empty
		end

feature {NONE} -- Implementation

	append_map (xpath: STRING; action: PROCEDURE)
		do
			match_events_list.extend ([On_open, xpath, action])
		end

	fill_match_events (object: EL_REFLECTIVE; xpath, field_name: STRING)
		-- recursive procedure to fill `match_events_list'
		local
			xpath_element: STRING
		do
			match_events_list.extend ([On_open, xpath, agent push_item (field_name)])
			match_events_list.extend ([On_close, xpath, agent pop_item])

			across object.field_table as field loop
				if is_attribute (field.item) then
					append_map (xpath + Slash_at + field.key, agent set_item_attribute (field.item))

				elseif attached {EL_REFLECTED_STORABLE} field.item as storable_field
					and then attached {EL_REFLECTIVELY_SETTABLE_STORABLE} storable_field.value (object) as storable
				then
					xpath_element := xpath + Slash + field.key
					fill_match_events (storable, xpath_element, field.key)
				else
					append_map (xpath + Slash + field.key + Slash_text, agent set_item_attribute (field.item))
				end
			end
		end

	is_attribute (field: EL_REFLECTED_FIELD): BOOLEAN
		do
			if attached {EL_REFLECTED_NUMERIC_FIELD [NUMERIC]} field
				or else attached {EL_REFLECTED_ENUMERATION [NUMERIC]} field
				or else attached {EL_REFLECTED_BOOLEAN} field
			then
				Result := True
			end
		end

	item: EL_REFLECTIVE
		do
			Result := stack.item
		end

	pop_item
		do
			stack.remove
		end

	push_item (field_name: STRING)
		local
			new_item: G
		do
			if field_name.is_empty then
				create new_item.make_default
				stack.put (new_item)
				chain.extend (new_item)

			elseif item.field_table.has_key (field_name)
				and then attached {EL_REFLECTIVE} item.field_table.found_item.value (item) as field_item
			then
				stack.put (field_item)
			end
		end

	set_item_attribute (field: EL_REFLECTED_FIELD)
		do
			if attached {EL_REFLECTED_ENUMERATION [NUMERIC]} field then
				field.set_from_string (item, last_node.raw_string_32 (True))
			elseif attached {EL_REFLECTED_STORABLE_TUPLE} field as tuple_field then
				tuple_field.set_from_string (item, last_node.raw_string_32 (True))
			else
				field.set_from_readable (item, last_node)
			end
		end

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		do
			Result := match_events_list.to_array
		end

feature {NONE} -- Internal attributes

	chain: ECD_REFLECTIVE_RECOVERABLE_CHAIN [G]

	file_path: EL_FILE_PATH

	match_events_list: ARRAYED_LIST [EL_XPATH_TO_AGENT_MAP]

	stack: ARRAYED_STACK [EL_REFLECTIVE]

feature {NONE} -- Constants

	Slash: STRING = "/"

	Slash_at: STRING = "/@"

	Slash_item: STRING = "/item"

	Slash_text: STRING = "/text()"

end