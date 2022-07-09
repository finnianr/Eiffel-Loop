note
	description: "ECF lines grouped under a custom tag: ''debugging: settings:'' etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-08 9:40:07 GMT (Friday 8th July 2022)"
	revision: "9"

deferred class
	GROUPED_ECF_LINES

inherit
	EL_SPLIT_ON_CHARACTER [STRING]
		rename
			make as make_split
		export
			{NONE} all
			{ANY} count
		redefine
			count, new_cursor
		end

	PYXIS_ECF_CONSTANTS

feature {NONE} -- Initialization

	make
		do
			create target.make_empty
			separator := '%N'
		end

feature -- Access

	new_cursor: GROUPED_LINES_CURSOR
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, tab_count)
		end

	tag_name: STRING
		deferred
		end

feature -- Measurement

	count: INTEGER
		do
			if target.count > 0 then
				Result := target.occurrences ('%N') + 1
			end
		end

	tab_count: INTEGER

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
			tab_count := 0
			first_line_removed := False
		end

feature -- Status query

	is_platform_rule (line: STRING): BOOLEAN
		do
			Result := False
		end

	is_related_line (parser: PYXIS_ECF_PARSER; line: STRING; equal_index, indent_count, end_index: INTEGER): BOOLEAN
		do
			Result := False
		end

	is_truncateable: BOOLEAN

feature -- Element change

	set_from_line (a_line: STRING)
		do
			wipe_out
			if attached shared_name_value_list (a_line) as nvp_list then
				set_from_pair_list (nvp_list)
			end
			if is_truncateable and then not first_line_removed then
				-- Remove element open tag which has already been processed
				remove_first
				first_line_removed := True
			end
		end

	set_indent (a_tab_count: INTEGER)
		do
			tab_count := a_tab_count
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

	remove_first
		local
			i: INTEGER
		do
			i := target.index_of ('%N', 1)
			if i > 0 then
				target.remove_head (i)
			else
				target.wipe_out
			end
		end

	set_from_pair_list (nvp_list: like Once_name_value_list)
		do
			across nvp_list as list loop
				set_variables (list.item)
				if target.count > 0 then
					target.append_character ('%N')
				end
				Template.substitute_to (target)
			end
		end

	set_variables (nvp: EL_NAME_VALUE_PAIR [STRING])
		do
			template.put (Var.element, tag_name)
			template.put (Var.name, nvp.name)
			template.put (Var.value, nvp.value)
		end

	wipe_out
		do
			target.wipe_out
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