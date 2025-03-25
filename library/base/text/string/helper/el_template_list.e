note
	description: "[
		List of literal strings and template substitution place holders
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-25 14:14:35 GMT (Tuesday 25th March 2025)"
	revision: "2"

deferred class
	EL_TEMPLATE_LIST [S -> STRING_GENERAL create make end, KEY -> READABLE_STRING_GENERAL]

inherit
	EL_STRING_LIST [S]
		rename
			append_to as substitute_to,
			joined_strings as substituted,
			item as list_item,
			item_count as list_item_count,
			has as has_item,
			put as put_item,
			make as make_list
		export
			{NONE} all
			{ANY} substituted, substitute_to
		redefine
			initialize
		end

	EL_MODULE_EXCEPTION

	EL_SHARED_OBJECT_POOL

	EL_REFLECTION_HANDLER

feature {NONE} -- Initialization

	initialize
		do
			Precursor; is_strict := True
		end

feature -- Status query

	has (name: KEY): BOOLEAN
		deferred
		end

	is_strict: BOOLEAN
		-- when true, enforces precondition that variables exist and raises an exception if a variable is not found

feature -- Status change

	disable_strict
		do
			is_strict := False
		end

feature -- Set variable values

	put (name: KEY; value: S)
		require
			has_name: is_strict implies has (name)
		do
			if attached found_item (name) as place_holder then
				place_holder.keep_head (0)
				place_holder.append (value)

			elseif is_strict then
				Exception.raise_developer ("class {%S}: Variable %"%S%" not found", [generator, name])
			end
		end

	put_any (name: KEY; value: ANY)
		do
			if attached {READABLE_STRING_GENERAL} value as general then
				put_general (name, general)
			else
				put_general (name, value.out)
			end
		end

	put_array (nvp_list: ARRAY [TUPLE [name: KEY; value: ANY]])
			--
		require
			valid_variables: is_strict implies across nvp_list as tuple all has (tuple.item.name) end
		do
			across nvp_list as tuple loop
				put_any (tuple.item.name, tuple.item.value)
			end
		end

	put_fields (object: ANY)
		-- set variables in template that match field names of `object'
		local
			i, field_count: INTEGER
		do
			if attached {EL_REFLECTIVE} object as reflective and then attached reflective.field_table as field_table then
				across place_holder_table as table loop
					if field_table.has_key_general (table.key) then
						put_general (table.key, field_table.found_item.to_string (reflective))
					end
				end
			elseif attached new_current_object (object) as meta_object then
				field_count := meta_object.field_count
				from i := 1 until i > field_count loop
					if attached field_key (meta_object.field_name (i)) as field_name
						and then (is_strict implies has (field_name))
					then
						put_any (field_name, meta_object.field (i))
					end
					i := i + 1
				end
				recycle (meta_object)
			end
		end

	put_general (name: KEY; value: READABLE_STRING_GENERAL)
		do
			put (name, new_string (value))
		end

	put_quoted (name: KEY; value: READABLE_STRING_GENERAL)
		local
			quoted: S
		do
			create quoted.make (value.count + 2)
			quoted.append_code ({EL_ASCII}.Doublequote)
			quoted.append (new_string (value))
			quoted.append_code ({EL_ASCII}.Doublequote)
			put (name, quoted)
		end

feature {NONE} -- Implementation

	found_item (name: KEY): detachable S
		deferred
		end

	field_key (str: READABLE_STRING_8): KEY
		deferred
		end

	key (str: KEY): READABLE_STRING_GENERAL
		deferred
		end

	place_holder_table: EL_HASH_TABLE [S, KEY]
		deferred
		end

end