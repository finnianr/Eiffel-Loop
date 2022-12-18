note
	description: "Table data importer from Pyxis data file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-18 12:37:53 GMT (Sunday 18th December 2022)"
	revision: "17"

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

	EL_MODULE_CONVERT_STRING

create
	make

feature {NONE} -- Initialization

	make (a_chain: like chain; a_file_path: FILE_PATH)
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
			xpath_element: STRING; i: INTEGER
		do
			match_events_list.extend ([On_open, xpath, agent push_item (field_name)])
			match_events_list.extend ([On_close, xpath, agent pop_item])

			across object.field_table as field loop
				if is_attribute (field.item) then
					append_map (xpath + Slash_at + field.key, agent set_item_attribute (field.item))

				elseif attached {EL_REFLECTED_STORABLE} field.item as storable_field then
					if attached {EL_REFLECTIVELY_SETTABLE_STORABLE} storable_field.value (object) as storable then
						xpath_element := xpath + Slash + field.key
						fill_match_events (storable, xpath_element, field.key)
					end
				elseif attached {EL_REFLECTED_TUPLE} field.item as tuple
					and then attached tuple.field_name_list as name_list
				then
					if attached tuple.member_types as tuple_types then
						from i := 1 until i > tuple_types.count loop
							xpath_element := xpath + Slash + field.key + Slash_at + name_list [i]
							append_map (xpath_element, agent set_item_tuple_i_th (tuple, i, tuple_types [i].type_id))
							i := i + 1
						end
					end
				else
					append_map (xpath + Slash + field.key + Slash_text, agent set_item_attribute (field.item))
				end
			end
		end

	is_attribute (field: EL_REFLECTED_FIELD): BOOLEAN
		do
			if attached {EL_REFLECTED_NUMERIC_FIELD [NUMERIC]} field
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
			if attached {G} stack.item as new_item then
				-- needs to be extended during pop so that indexing works
				chain.extend (new_item)
			end
			stack.remove
		end

	push_item (field_name: STRING)
		local
			new_item: G
		do
			if field_name.is_empty then
				create new_item.make_default
				stack.put (new_item)

			elseif item.field_table.has_key (field_name)
				and then attached {EL_REFLECTIVE} item.field_table.found_item.value (item) as field_item
			then
				stack.put (field_item)
			end
		end

	set_item_attribute (field: EL_REFLECTED_FIELD)
		do
			if attached {EL_REFLECTED_EXPANDED_FIELD [ANY]} field as expanded_field
				and then expanded_field.has_string_representation
			then
				expanded_field.set_from_string (item, last_node.raw_string_32 (True))
			elseif attached {EL_REFLECTED_TUPLE} field as tuple then
				tuple.set_from_string (item, last_node.raw_string_32 (True))
			else
				field.set_from_readable (item, last_node)
			end
		end

	set_item_tuple_i_th (field: EL_REFLECTED_TUPLE; i: INTEGER; i_th_type_id: INTEGER)
		do
			if attached field.value (item) as tuple_item then
				tuple_item.put (Convert_string.to_type_of_type (last_node.to_string, i_th_type_id), i)
			end
		end

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		do
			Result := match_events_list.to_array
		end

feature {NONE} -- Internal attributes

	chain: ECD_REFLECTIVE_RECOVERABLE_CHAIN [G]

	file_path: FILE_PATH

	match_events_list: ARRAYED_LIST [EL_XPATH_TO_AGENT_MAP]

	stack: ARRAYED_STACK [EL_REFLECTIVE]

feature {NONE} -- Constants

	Slash: STRING = "/"

	Slash_at: STRING = "/@"

	Slash_item: STRING = "/item"

	Slash_text: STRING = "/text()"

end