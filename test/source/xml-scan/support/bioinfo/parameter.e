note
	description: "Parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 15:02:17 GMT (Saturday 24th June 2023)"
	revision: "9"

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
		local
			new_line: BOOLEAN; lower_class: STRING
		do
			log.enter_no_header ("display")
			lower_class := generator.as_lower
			log.put_labeled_string ("class", lower_class)
			log.put_string_field (" id", id)
			if lower_class.count + id.count + label.count + run_switch.count > 35 then
				new_line := True
			end
			if not label.is_empty then
				if new_line then
					log.put_new_line
				else
					log.put_spaces (1)
				end
				new_line := False
				log.put_string_field ("label", label)
			end
			if not run_switch.is_empty then
				if new_line then
					log.put_new_line
				else
					log.put_spaces (1)
				end
				log.put_string_field ("Run switch", run_switch)
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

	set_descendant_context (a_descendant: PARAMETER)
		do
			descendant := a_descendant
			set_next_context (a_descendant)
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

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: par
		do
			create Result.make (<<
				["id/text()", agent do node.set_8 (id) end],
				["label/text()", agent do node.set_8 (label) end],
				["runSwitch/text()", agent do node.set_8 (run_switch) end],

			-- Recursive
				["value[@type='container']", agent do set_descendant_context (create {CONTAINER_PARAMETER}.make) end],
				["value[@type='choice']", agent do set_descendant_context (create {CHOICE_PARAMETER}.make) end],

			-- Non-recursive
				["value[@type='title']", agent do set_descendant_context (create {TITLE_PARAMETER}.make) end],
				["value[@type='string']", agent do set_descendant_context (create {VALUE_PARAMETER}.make) end],
				["value[@type='url']", agent do set_descendant_context (create {URL_PARAMETER}.make) end],
				["value[@type='rules']", agent set_rules_list_parameter_descendant],
				["value[@type='data']", agent do set_descendant_context (create {DATA_PARAMETER}.make) end],
				["value[@type='list']", agent do set_descendant_context (create {STRING_LIST_PARAMETER}.make) end],

				["value[@type='boolean']", agent do set_descendant_context (create {BOOLEAN_PARAMETER}.make) end],
				["value[@type='integer']", agent do set_descendant_context (create {INTEGER_PARAMETER}.make) end],
				["value[@type='float']", agent do set_descendant_context (create {REAL_PARAMETER}.make) end],

				["value[@type='intRange']", agent set_integer_range_list_parameter_descendant],
				["value[@type='floatRange']", agent set_real_range_list_parameter_descendant]
			>>)
		end

feature {NONE} -- Constants

	Default_descendant: DEFAULT_PARAMETER
			--
		once
			create Result.make
		end

	Text_node: STRING = "text()"
end