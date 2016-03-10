note
	description: "Summary description for {PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-15 8:51:07 GMT (Tuesday 15th December 2015)"
	revision: "4"

class
	PARAMETER

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make, building_action_table
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create id.make_empty
			create label.make_empty
			create run_switch.make_empty
			descendant := Default_descendant
		end

feature -- Access

	id: STRING

	label: STRING

	run_switch: STRING

	merged_descendant: like descendant
			-- Merge Current with descendant
		do
			if descendant = Default_descendant then
				Result := Current
			else
				Result := descendant
				Result.set_from_other (Current)
			end
		end

feature -- Element change

	set_from_other (other: PARAMETER)
			--
		do
			id := other.id
			label := other.label
			run_switch := other.run_switch
		end

feature -- Basic operations

	display
			--
		do
			log.enter_no_header ("display")
			log.put_labeled_string ("class", generator.as_lower)
			log.put_string_field (" id", id)
			if not label.is_empty then
				log.put_string_field (" label", label)
			end
			if not run_switch.is_empty then
				log.put_string_field (" Run switch", run_switch)
			end
			display_item
			log.exit_no_trailer
		end

feature {NONE} -- Implementation

	descendant: PARAMETER

	display_item
			--
		do
		end

feature {NONE} -- Build from XML

	set_label_item
			--
		do
			label := node.to_string
		end

	set_id_item
			--
		do
			id := node.to_string
		end

	set_run_switch
			--
		do
			run_switch := node.to_string
		end

	set_container_parameter_descendant
			--
		do
			create {CONTAINER_PARAMETER} descendant.make  -- Recursive class
			set_next_context (descendant)
		end

	set_choice_parameter_descendant
			--
		do
			create {CHOICE_PARAMETER} descendant.make -- Recursive class
			set_next_context (descendant)
		end

	set_title_parameter_descendant
			--
		do
			create {TITLE_PARAMETER} descendant.make
			set_next_context (descendant)
		end

	set_string_parameter_descendant
			--
		do
			create {STRING_PARAMETER} descendant.make
			set_next_context (descendant)
		end

	set_url_parameter_descendant
			--
		do
			create {URL_PARAMETER} descendant.make
			set_next_context (descendant)
		end

	set_data_parameter_descendant
			--
		do
			create {DATA_PARAMETER} descendant.make
			set_next_context (descendant)
		end

	set_boolean_parameter_descendant
			--
		do
			create {BOOLEAN_PARAMETER} descendant.make
			set_next_context (descendant)
		end

	set_integer_parameter_descendant
			--
		do
			create {INTEGER_PARAMETER} descendant.make
			set_next_context (descendant)
		end

	set_integer_range_list_parameter_descendant
			--
		do
			if not attached {INTEGER_RANGE_LIST_PARAMETER} descendant as integer_range_list then
				create {INTEGER_RANGE_LIST_PARAMETER} descendant.make
			end
			set_next_context (descendant)
		end

	set_real_range_list_parameter_descendant
			--
		do
			if not attached {REAL_RANGE_LIST_PARAMETER} descendant as real_range_list then
				create {REAL_RANGE_LIST_PARAMETER} descendant.make
			end
			set_next_context (descendant)
		end

	set_rules_list_parameter_descendant
			--
		do
			if not attached {RULES_LIST_PARAMETER} descendant as rules_list then
				create {RULES_LIST_PARAMETER} descendant.make
			end
			set_next_context (descendant)
		end

	set_string_list_parameter_descendant
			--
		do
			create {STRING_LIST_PARAMETER} descendant.make
			set_next_context (descendant)
		end

	set_real_parameter_descendant
			--
		do
			create {REAL_PARAMETER} descendant.make
			set_next_context (descendant)
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: par
		do
			create Result.make (<<
				["id/text()", agent set_id_item],
				["label/text()", agent set_label_item],
				["runSwitch/text()", agent set_run_switch],

				["value[@type='container']", agent set_container_parameter_descendant], 	-- Recursive builder routine
				["value[@type='choice']", agent set_choice_parameter_descendant], 			-- Recursive builder routine

				["value[@type='title']", agent set_title_parameter_descendant],
				["value[@type='string']", agent set_string_parameter_descendant],
				["value[@type='url']", agent set_url_parameter_descendant],
				["value[@type='rules']", agent set_rules_list_parameter_descendant],
				["value[@type='data']", agent set_data_parameter_descendant],
				["value[@type='list']", agent set_string_list_parameter_descendant],

				["value[@type='boolean']", agent set_boolean_parameter_descendant],
				["value[@type='integer']", agent set_integer_parameter_descendant],
				["value[@type='float']", agent set_real_parameter_descendant],

				["value[@type='intRange']", agent set_integer_range_list_parameter_descendant],
				["value[@type='floatRange']", agent set_real_range_list_parameter_descendant]
			>>)
		end

feature {NONE} -- Constants

	Default_descendant: PARAMETER
			--
		once
			create Result.make
		end

end
