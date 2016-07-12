note
	description: "Summary description for {BIOINFO_XPATH_MATCH_EVENT_PROCESSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 10:39:37 GMT (Friday 8th July 2016)"
	revision: "7"

class
	BIOINFO_XPATH_MATCH_EVENTS

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

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
		local
			node_string: ZSTRING
		do
			node_string := last_node.to_string
			if node_string.starts_with_general ("Help") then
				lio.put_string_field_to_max_length ("HELP LABEL", node_string, 100)
				lio.put_new_line
				lio.put_new_line
			end
		end

	on_par_id
			--
		do
			if last_node.to_string.same_string ("globalrules") then
				par_id_globalrules_count := par_id_globalrules_count + 1
			end
		end

	on_parameter_list_value_type
			--
		do
			is_type_url := last_node.to_string.same_string ("url")
			log_last_node ("TYPE")
		end

	on_parameter_list_value
			--
		do
			if is_type_url and then last_node.to_string.starts_with_general ("http:") then
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

	xpath_match_events: ARRAY [like Type_agent_mapping]
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
			lio.put_string_field (label, last_node.to_string)
			lio.put_new_line
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
