note
	description: "Summary description for {FCGI_HTTP_HEADERS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-27 12:15:56 GMT (Monday 27th November 2017)"
	revision: "1"

class
	FCGI_HTTP_HEADERS

inherit
	EL_REFLECTIVELY_SETTABLE [ZSTRING]
		rename
			make_default as make
		redefine
			set_field, make, Except_fields, name_adaptation
		end

	EL_STRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create custom_table.make (3)
		end

feature -- Element change

	set_authorization (a_authorization: like authorization)
		do
			authorization := a_authorization
		end

	set_custom (name: STRING; value: ZSTRING)
		local
			kebab_name: STRING
		do
			create kebab_name.make (name.count)
			from_kebab_case (name, kebab_name)
			custom_table [kebab_name] := value
		end

	wipe_out
		do
			set_default_values
			custom_table.wipe_out
			content_length := -1
		end

feature -- Access

	as_table (kebab_names: BOOLEAN): HASH_TABLE [ZSTRING, STRING]
		-- table of all non-empty headers with name-keys adjusted to use hyphen word separator
		-- if `kebab_names' is true
		local
			object: like current_object; value: ZSTRING
			table: like field_index_table
		do
			object := current_object; table := field_index_table
			create Result.make (custom_table.count + 7)
			from table.start until table.after loop
				value := field_item_from_index (table.item_for_iteration)
				if not value.is_empty then
					Result [as_table_key (table.key_for_iteration, kebab_names)] := value
				end
				table.forth
			end
			from custom_table.start until custom_table.after loop
				value := custom_table.item_for_iteration
				if not value.is_empty then
					Result [as_table_key (custom_table.key_for_iteration, kebab_names)] := value
				end
				custom_table.forth
			end
		end

	custom (name: STRING): ZSTRING
		local
			kebab_name: STRING
		do
			create kebab_name.make (name.count)
			from_kebab_case (name, kebab_name)
			custom_table.search (kebab_name)
			if custom_table.found then
				Result := custom_table.found_item
			else
				create Result.make_empty
			end
		end

	selected (name_list: EL_SPLIT_ZSTRING_LIST): HASH_TABLE [ZSTRING, STRING]
		-- returns table of field values for keys present in `name_list'
		local
			name: STRING; object: like current_object
		do
			name := String_pool.new_string; object := current_object

			create Result.make (name_list.count)
			from name_list.start until name_list.after loop
				name.wipe_out
				name_list.item.append_to_string_8 (name)
				String_8.replace_character (name, '-', '_')
				name.to_lower

				field_index_table.search (name)
				if field_index_table.found then
					Result.extend (field_item_from_index (field_index_table.found_item), name_list.item.twin)
				else
					custom_table.search (name)
					if custom_table.found then
						Result.extend (custom_table.found_item, name_list.item.twin)
					end
				end
				name_list.forth
			end
			String_pool.recycle (name)
		end

feature -- Access attributes

	accept: ZSTRING

	accept_encoding: ZSTRING

	accept_language: ZSTRING

	authorization: ZSTRING

	cache_control: ZSTRING

	connection: ZSTRING

	content_length: INTEGER

	content_type: ZSTRING

	cookie: ZSTRING


	from_: ZSTRING
		-- Trailing `_' to distinguish from Eiffel keyword

	host: ZSTRING

	referer: ZSTRING

	upgrade_insecure_requests: ZSTRING

	user_agent: ZSTRING

	x_forwarded_host: ZSTRING

feature -- Element change

	set_field (name: STRING; value: ZSTRING)
		do
			Precursor (name, value)
			if not field_index_table.found then
				custom_table.extend (value, name.as_lower)
			end
		end

feature {NONE} -- Implementation

	as_table_key (name: STRING; kebab_names: BOOLEAN): STRING
		do
			if kebab_names then
				Result := to_kebab_case (name)
			else
				Result := name
			end
		end

	name_adaptation: like Standard_eiffel
		do
			Result := agent from_upper_snake_case
		end

feature {NONE} -- Internal attributes

	custom_table: HASH_TABLE [ZSTRING, STRING]
		-- custom_table fields prefixed with x_

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", custom_table"
		end

end
