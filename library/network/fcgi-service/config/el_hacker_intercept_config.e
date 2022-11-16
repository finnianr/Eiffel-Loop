note
	description: "Hacker intercept configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_HACKER_INTERCEPT_CONFIG

inherit
	FCGI_SERVICE_CONFIG
		redefine
			building_action_table, make_default
		end

	EL_MODULE_FILE; EL_MODULE_TUPLE

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create filter_table.make (5)
		end

feature -- Status report

	is_hacker_probe (path_lower: ZSTRING): BOOLEAN
		local
			key: STRING
		do
			across filter_table as table until Result loop
				key := table.key
				if key = Predicate.starts_with then
					Result := across table.item as string some path_lower.starts_with (string.item) end

				elseif key = Predicate.ends_with then
					Result := across table.item as string some path_lower.ends_with (string.item) end

				elseif key = Predicate.is_equal_ then
					Result := across table.item as string some path_lower.is_equal (string.item) end

				elseif key = Predicate.has_substring then
					Result := across table.item as string some path_lower.has_substring (string.item) end
				end
			end
		end

feature -- Basic operations

	block (ip_address: STRING)
		do
			File.write_text (Block_ip_path, ip_address)
		end

feature -- Constants

	Block_ip_path: FILE_PATH
		once
			Result := server_socket_path.parent + "block-ip.txt"
		end

feature {NONE} -- Build from XML

	append_filter (a_predicate: STRING)
		do
			across node.to_string.lines as line loop
				across line.item.split (';') as split loop
					filter_table.extend (a_predicate, split.item_copy)
				end
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		local
			l_xpath: STRING; predicate_list: EL_STRING_8_LIST
		do
			Result := Precursor
			create predicate_list.make_from_tuple (Predicate)
			across predicate_list as list loop
				l_xpath := Xpath_match_list #$ [list.item]
				Result [l_xpath] := agent append_filter (list.item)
			end
		end

feature {NONE} -- Internal attributes

	filter_table: EL_GROUP_TABLE [ZSTRING, STRING]

feature {NONE} -- Constants

	Predicate: TUPLE [starts_with, has_substring, ends_with, is_equal_: STRING]
		once
			create Result
			Tuple.fill (Result, "starts_with, has_substring, ends_with, is_equal")
		end

	Xpath_match_list: ZSTRING
		once
			Result := "match-%S/text()"
		end

end