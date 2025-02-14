note
	description: "Hacker intercept configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-14 12:39:52 GMT (Friday 14th February 2025)"
	revision: "15"

class
	EL_404_INTERCEPT_CONFIG

inherit
	FCGI_SERVICE_CONFIG
		redefine
			building_action_table, make_default
		end

	EL_MODULE_TUPLE

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			create filter_table.make
			create last_white_list_name.make_empty
			slash := '/'
			Precursor
		end

feature -- Access

	maximum_rule_count: INTEGER
		-- max. number of IP addresses that can be blocked with
		-- Older blocks are removed to make way for newer ones.

	filter_table: EL_URI_FILTER_TABLE

feature {NONE} -- Build from XML

	append_filter (a_predicate: STRING)
		do
			across node.adjusted (False).lines as line loop
				across line.item.split (';') as split loop
					filter_table.extend (split.item_copy, a_predicate)
				end
			end
		end

	append_white_listed (is_directory_item: BOOLEAN)
		do
			across node.adjusted (False).lines as line loop
				across line.item.split (';') as split loop
					if is_directory_item then
						filter_table.put_whitelist (slash.joined (last_white_list_name, split.item))
					else
						if last_white_list_name.is_empty then
							filter_table.put_whitelist (split.item_copy)
						elseif split.item.count = 1 and then split.item [1] = '/' then
							filter_table.put_whitelist (last_white_list_name.twin)
						else
							filter_table.put_whitelist (slash.joined (split.item, last_white_list_name))
						end
					end
				end
			end
			last_white_list_name.wipe_out
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["@maximum_rule_count",						agent do maximum_rule_count := node end],
				["@maximum_uri_digits",						agent do filter_table.set_maximum_uri_digits (node) end],

				["white_listed/item/@name",				agent do node.set (last_white_list_name) end],
				["white_listed/item/text()",				agent append_white_listed (False)],

				["white_listed/directory_item/@name",	agent do node.set (last_white_list_name) end],
				["white_listed/directory_item/text()",	agent append_white_listed (True)]
			>>)

			across filter_table.predicate_list as list loop
				if attached (Xpath_match_list #$ [list.item]) as l_xpath then
					Result [l_xpath] := agent append_filter (list.item)
				end
			end
		end

feature {NONE} -- Internal attributes

	last_white_list_name: ZSTRING

	slash: EL_CHARACTER_32

feature {NONE} -- Internal attributes

	Xpath_match_list: ZSTRING
		once
			Result := "match-%S/text()"
		end

end