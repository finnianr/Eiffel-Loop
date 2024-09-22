note
	description: "Fast-CGI HTTP headers and custom headers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:49:23 GMT (Sunday 22nd September 2024)"
	revision: "26"

class
	FCGI_HTTP_HEADERS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as Snake_case_upper,
			make_default as make,
			field_included as is_any_field
		redefine
			make
		end

	EL_SETTABLE_FROM_STRING_8
		rename
			make_default as make
		redefine
			set_table_field_utf_8
		end

	EL_MODULE_ITERABLE; EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create custom_table.make (3)
		end

feature -- Access

	as_table (translater: EL_NAME_TRANSLATER): EL_HASH_TABLE [ZSTRING, STRING]
		-- table of all non-empty headers with name-keys adjusted to use hyphen word separator
		-- if `kebab_names' is true
		local
			table: like field_table; value: ZSTRING
		do
			table := field_table
			create Result.make (custom_table.count + 7)
			from table.start until table.after loop
				value := field_string (table.item_for_iteration)
				if not value.is_empty then
					Result [translater.exported (table.key_for_iteration)] := value
				end
				table.forth
			end
			from custom_table.start until custom_table.after loop
				value := custom_table.item_for_iteration
				if not value.is_empty then
					Result [translater.exported (custom_table.key_for_iteration)] := value
				end
				custom_table.forth
			end
		end

	custom (name: STRING): ZSTRING
		local
			kebab_name: STRING
		do
			create kebab_name.make (name.count)
			Naming.from_kebab_case (name, kebab_name)
			if custom_table.has_key (kebab_name) then
				Result := custom_table.found_item
			else
				create Result.make_empty
			end
		end

	selected (name_list: ITERABLE [STRING]; translater: EL_NAME_TRANSLATER): EL_HASH_TABLE [ZSTRING, STRING]
		-- returns table of field values for keys present in `name_list'
		local
			l_name: STRING
		do
			create Result.make (Iterable.count (name_list))
			across name_list as name loop
				l_name := translater.imported (name.item)
				if field_table.has_key_8 (l_name) then
					Result.extend (field_string (field_table.found_item), name.item)
				else
					if custom_table.has_key (l_name) then
						Result.extend (custom_table.found_item, name.item)
					end
				end
			end
		end

feature -- BOOLEAN values

	upgrade_insecure_requests: BOOLEAN
		-- Upgrade-Insecure-Requests: 1

feature -- INTEGER value

	content_length: INTEGER

feature -- STRING_8 attributes

	accept: STRING
		-- Accept: text/html

	accept_encoding: STRING
		-- Accept-Encoding: gzip, deflate

	accept_language: STRING
		-- Accept-Language: en-US

	authorization: STRING
		-- Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==

	cache_control: STRING
		-- Cache-Control: no-cache

	connection: STRING
		-- Connection: keep-alive

	content_type: STRING
		-- Content-Type: text/html; charset=utf-8

	cookie: STRING

	from_: STRING
		-- Trailing `_' to distinguish from Eiffel keyword

	host: STRING

	referer: STRING

	user_agent: STRING

	x_forwarded_host: STRING

feature -- Element change

	set_accept (a_accept: STRING)
		do
			accept := a_accept
		end

	set_accept_encoding (a_accept_encoding: STRING)
		do
			accept_encoding := a_accept_encoding
		end

	set_accept_language (a_accept_language: STRING)
		do
			accept_language := a_accept_language
		end

	set_authorization (a_authorization: STRING)
		do
			authorization := a_authorization
		end

	set_cache_control (a_cache_control: STRING)
		do
			cache_control := a_cache_control
		end

	set_connection (a_connection: STRING)
		do
			connection := a_connection
		end

	set_content_length (a_content_length: INTEGER)
		do
			content_length := a_content_length
		end

	set_content_type (a_content_type: STRING)
		do
			content_type := a_content_type
		end

	set_cookie (a_cookie: STRING)
		do
			cookie := a_cookie
		end

	set_custom (name: STRING; value: ZSTRING)
		local
			kebab_name: STRING
		do
			create kebab_name.make (name.count)
			Naming.from_kebab_case (name, kebab_name)
			custom_table [kebab_name] := value
		end

	set_from (a_from: STRING)
		do
			from_ := a_from
		end

	set_host (a_host: STRING)
		do
			host := a_host
		end

	set_referer (a_referer: STRING)
		do
			referer := a_referer
		end

	set_upgrade_insecure_requests (a_upgrade_insecure_requests: BOOLEAN)
		do
			upgrade_insecure_requests := a_upgrade_insecure_requests
		end

	set_user_agent (a_user_agent: STRING)
		do
			user_agent := a_user_agent
		end

	wipe_out
		do
			reset_fields
			custom_table.wipe_out
			content_length := -1
		end

feature {NONE} -- Implementation

	set_table_field_utf_8 (table: like field_table; name, value_utf_8: READABLE_STRING_8)
		-- set field with name
		do
			Precursor (table, name, value_utf_8)
			if not table.found then
				custom_table.extend (create {ZSTRING}.make_from_utf_8 (value_utf_8), name.as_lower)
			end
		end

feature {NONE} -- Internal attributes

	custom_table: EL_STRING_8_TABLE [ZSTRING] note option: transient attribute end
		-- custom_table fields prefixed with x_

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end

end