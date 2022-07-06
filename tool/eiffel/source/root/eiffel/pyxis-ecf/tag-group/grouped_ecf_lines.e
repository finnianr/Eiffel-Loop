note
	description: "ECF lines grouped under a custom tag: ''debugging: settings:'' etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 15:53:05 GMT (Wednesday 6th July 2022)"
	revision: "6"

deferred class
	GROUPED_ECF_LINES

inherit
	EL_STRING_8_LIST
		rename
			make as make_list,
			make_empty as make
		export
			{NONE} all
			{ANY} count
		end

	EL_MODULE_TUPLE

	PYXIS_ECF_CONSTANTS

feature -- Access

	tag_name: STRING
		deferred
		end

feature -- Status change

	enable_truncation
		do
			is_truncateable := True
		end

	exit
		do
		end

	reset
		do
			wipe_out
			first_line_removed := False
		end

feature -- Status query

	is_truncateable: BOOLEAN

feature -- Element change

	set_from_line (a_line: STRING; tab_count: INTEGER)
		do
			wipe_out
			if attached shared_name_value_list (a_line) as nvp_list then
				set_from_pair_list (nvp_list, tab_count)
			end
			if is_truncateable and then not first_line_removed then
				-- Remove element open tag which has already been processed
				start; remove
				first_line_removed := True
			end
		end

feature -- Factory

	shared_name_value_list (line: STRING): detachable like Once_name_value_list
		local
			pair_splitter: like Once_pair_splitter
			nvp: EL_NAME_VALUE_PAIR [STRING]
		do
			pair_splitter := Once_pair_splitter
			pair_splitter.set_target (line)
			if attached Once_name_value_list as list then
				list.wipe_out
				across pair_splitter as split loop
					if split.item_has ('=') then
						create nvp.make (split.item, '=')
						nvp.name.adjust
						adjust_value (nvp.value)
						list.extend (nvp)
					end
				end
				if list.count > 0 then
					Result := list
				end
			end
		end

feature {NONE} -- Implementation

	adjust_value (value: STRING)
		do
		end

	expanded_template (nvp: EL_NAME_VALUE_PAIR [STRING]): STRING
		do
			set_variables (nvp)
			Result := template.substituted
		end

	set_from_pair_list (nvp_list: like Once_name_value_list; tab_count: INTEGER)
		do
			grow (nvp_list.count * 2)
			across nvp_list as list loop
				across expanded_template (list.item).split ('%N') as line loop
					extend (line.item)
				end
			end
			indent (tab_count)
		end

	set_variables (nvp: EL_NAME_VALUE_PAIR [STRING])
		do
			template.put (Var.element, tag_name)
			template.put (Var.name, nvp.name)
			template.put (Var.value, nvp.value)
		end

feature {NONE} -- Internal attributes

	first_line_removed: BOOLEAN

feature {NONE} -- Constants

	Once_name_value_list: EL_ARRAYED_LIST [EL_NAME_VALUE_PAIR [STRING]]
		once
			create Result.make (7)
		end

	Once_pair_splitter: EL_SPLIT_ON_CHARACTER [STRING]
		once
			create Result.make_adjusted ("", ';', {EL_STRING_ADJUST}.Left)
		end

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					name = $NAME; value = $VALUE
			]"
		end

end