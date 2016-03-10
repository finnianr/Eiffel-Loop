note
	description: "[
		Base class for an application configuration class.
		Configuration fields are editable either from the command line or a GUI editor.
		Change listeners can be registered for each editable field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_APP_CONFIGURATION

inherit
	ARGUMENTS
		export
			{NONE} all
		end
		
	EL_EDIT_LISTENER

feature {NONE} -- Initialization

	make
			--
		do
			set_option_sign ('-')
			create argument_info_list.make
			create field_change_actions.make (7)
			create field_array.make (7)
			field_array.compare_references
			
			create change_actions_to_apply.make
			change_actions_to_apply.compare_references
			
			create_editable_fields
			read_command_line_args
		end

	read_command_line_args
			--
		deferred
		end
		
	create_editable_fields
			--
		deferred
		end
	
feature -- Access

	command_line_help: STRING
			-- Informational string describing fields configurable from the application command line
		do
			create Result.make (argument_info_list.count * 80)
			from
				argument_info_list.start
			until
				argument_info_list.off
			loop
				Result.append (argument_info_list.item.info)
				if not argument_info_list.islast then
					Result.append_character ('%N')
					Result.append_character ('%N')
				end
				argument_info_list.forth
			end
		end

feature -- Basic operations

	register_change_action (monitored_fields: ARRAY [EL_EDITABLE_VALUE]; action: PROCEDURE [ANY, TUPLE])
			-- Register an action to be called if any of the monitored fields change in value
		local
			i: INTEGER
		do
			from i := 1 until i > monitored_fields.count loop
				-- Find index of each field
				field_array.start
				field_array.search (monitored_fields [i])
				if not field_array.exhausted then
					field_change_actions.search (field_array.index)
					if field_change_actions.found then
						field_change_actions.found_item.extend (action)
					end
				end
				i := i + 1
			end
		end
		
	notify_changes
			-- Apply registered change actions for any fields that have been edited
		do
			change_actions_to_apply.do_all (agent {PROCEDURE [ANY, TUPLE]}.apply)
			change_actions_to_apply.wipe_out
		end

feature {NONE} -- Implementation

	on_change (edited_field: EL_EDITABLE_VALUE)
			--
		do
			field_array.start
			field_array.search (edited_field)
			if not field_array.exhausted then
				field_change_actions.search (field_array.index)
				if field_change_actions.found then
					field_change_actions.found_item.do_all (agent change_actions_to_apply.extend)
				end
			end
		end

	add_field (field: EL_EDITABLE_VALUE)
			--
		require
			field_is_unique: not field_array.has (field)
		do
			field_array.extend (field)
			field_change_actions.put (
				create {LINKED_LIST [PROCEDURE [ANY, TUPLE]]}.make, field_array.count
			)
			
		end
		
	set_argument (option_name: STRING; config_field: EL_EDITABLE_VALUE; info_template: STRING)
			-- If command line option with 'option_name' is present, set the configuration field with
			-- the option value
			
			-- $VALUE is substituted in info template with current option_name value
		require
			info_template_has_a_substitution_variable: info_template.has_substring ("$VALUE")
		local
			option_index: INTEGER
		do
			option_index := index_of_word_option (option_name)
			
			if option_index > 0 and option_index < argument_count then
				config_field.set_item (argument (option_index + 1))
				if not config_field.is_last_edit_valid then
					put_error_message (option_name, argument (option_index + 1))
				end
			end
			argument_info_list.extend (
				create {EL_COMMAND_LINE_ARG}.make (info_template, config_field)
			)
		end

	set_option (option_name: STRING; config_boolean_field: EL_EDITABLE_BOOLEAN; info_template: STRING)
			-- If command line option with 'option_name' is present, set the configuration field to true

			-- $VALUE is substituted in info template with current option_name value
		require
			info_template_has_a_substitution_variable: info_template.has_substring ("$VALUE")
		do
			if index_of_word_option (option_name) > 0 then
				config_boolean_field.set_item ("true")
			end
			argument_info_list.extend (
				create {EL_COMMAND_LINE_ARG}.make (info_template, config_boolean_field)
			)
		end

	put_error_message (option_name: STRING; config_field: STRING)
			--
		deferred
		end
		
	argument_info_list: LINKED_LIST [EL_COMMAND_LINE_ARG]
	
	field_array: ARRAYED_LIST [EL_EDITABLE_VALUE]

	field_change_actions: HASH_TABLE [LINKED_LIST [PROCEDURE [ANY, TUPLE]], INTEGER]
	
	change_actions_to_apply: LINKED_SET [PROCEDURE [ANY, TUPLE]]

end




