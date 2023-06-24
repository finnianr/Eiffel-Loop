note
	description: "[
		Class that scans the example XML document 
		[https://github.com/finnianr/Eiffel-Loop/blob/master/projects.data/vtd-xml/bioinfo.xml bioinfo.xml],
		outputting node values defined by the xpath to agent mapping `xpath_match_events'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 7:29:14 GMT (Saturday 24th June 2023)"
	revision: "16"

class
	BIOINFO_XPATH_MATCH_EVENTS

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

	EL_XML_PARSE_EVENT_TYPE

	EL_MODULE_LOG

create
	make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			create label_count
			create par_id_count
			create data_value_field_set.make (21)
		end

feature {NONE} -- XPath match event handlers

	on_package_env
			--
		do
			log_last_node ("PACKAGE ENVIRONMENT")
		end

	on_command_action
			--
		do
			log_last_node ("COMMAND ACTION")
		end

	on_label
			--
		do
			if attached last_node.adjusted_8 (False) as str and then str.starts_with ("Help") then
				lio.put_curtailed_string_field ("HELP LABEL", str, 100)
				lio.put_new_line
				lio.put_new_line
			end
		end

	on_par_id
			--
		do
			if last_node.same_as_8 ("globalrules") then
				par_id_globalrules_count := par_id_globalrules_count + 1
			end
		end

	on_parameter_list_value_type
			--
		do
			is_type_url := last_node.same_as_8 ("url")
			log_last_node ("TYPE")
		end

	on_parameter_list_value
			--
		do
			if is_type_url and then last_node.adjusted_8 (False).starts_with ("http:") then
				log_last_node ("HTTP URL")
			end
		end

	on_parameter_data_value_field
			--
		do
			data_value_field_set.put (last_node.name)
		end

	log_results
			--
		do
			log.enter ("log_results")
			log.put_integer_field ("count(//label)", label_count)
			log.put_new_line
			log.put_integer_field ("count(//par/id)", par_id_count)
			log.put_new_line
			log.put_integer_field ("count(//par/id [text()='globalrules'])", par_id_globalrules_count)
			log.put_new_line
			log.put_new_line

			log.put_line ("VALUE FIELDS:")
			across data_value_field_set as value loop
				log.put_line (value.item)
			end
			log.exit
		end

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		do
			Result := <<
				-- Fixed paths
				[on_open, "/bix/package/env/text()", agent on_package_env],
				[on_open, "/bix/package/command/action/text()", agent on_command_action],
				[on_open, "/bix/package/command/parlist/par/value/@type", agent on_parameter_list_value_type],
				[on_open, "/bix/package/command/parlist/par/value/text()", agent on_parameter_list_value],

				[on_close, "/bix", agent log_results], -- matches only when closing tag encountered

				-- Wildcard paths
				[on_open, "//par/value/*", agent on_parameter_data_value_field],
				[on_open, "//label/text()", agent on_label],
				[on_open, "//label", agent increment (label_count)],
				[on_open, "//par/id", agent increment (par_id_count)],

				[on_open, "//par/id/text()", agent on_par_id]
			>>
		end

	log_last_node (label: STRING)
			--
		do
			if attached last_node.adjusted (False) as str then
				lio.put_curtailed_string_field (label, str, str.count)
			end
			lio.put_new_line
		end

	increment (counter: INTEGER_REF)
			--
		do
			counter.set_item (counter.item + 1)
		end

	data_value_field_set: EL_HASH_SET [STRING]

	label_count: INTEGER_REF

	par_id_count: INTEGER_REF

	par_id_globalrules_count: INTEGER

	is_type_url: BOOLEAN

end