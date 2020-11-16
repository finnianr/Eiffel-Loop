note
	description: "Hacker intercept configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-16 10:04:16 GMT (Monday 16th November 2020)"
	revision: "3"

class
	EL_HACKER_INTERCEPT_CONFIG

inherit
	FCGI_SERVICE_CONFIG
		redefine
			building_action_table, make_default
		end

	EL_MODULE_FILE_SYSTEM

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create filter_list.make (20)
		end

feature -- Access

	filter_list: EL_ARRAYED_LIST [PREDICATE [ZSTRING]]

feature -- Basic operations

	block (ip_address: STRING)
		do
			File_system.write_plain_text (Block_ip_path, ip_address)
		end

feature -- Constants

	Block_ip_path: EL_FILE_PATH
		once
			Result := server_socket_path.parent + "block-ip.txt"
		end

feature {NONE} -- Build from XML

	append_filter (type: INTEGER)
		do
			across node.to_string.lines as line loop
				inspect type
					when 1 then
						filter_list.extend (agent {ZSTRING}.starts_with (line.item))
					when 2 then
						filter_list.extend (agent {ZSTRING}.has_substring (line.item))
					when 3 then
						filter_list.extend (agent {ZSTRING}.ends_with (line.item))
					when 4 then
						filter_list.extend (agent {ZSTRING}.is_equal (line.item))
				else end
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		local
			l_xpath: STRING
		do
			Result := Precursor
			across << "starts_with", "has_substring", "ends_with", "is_equal" >> as predicate loop
				l_xpath := Xpath_match_list #$ [predicate.item]
				Result [l_xpath] := agent append_filter (predicate.cursor_index)
			end
		end

feature {NONE} -- Constants

	Xpath_match_list: ZSTRING
		once
			Result := "match-%S/text()"
		end

end