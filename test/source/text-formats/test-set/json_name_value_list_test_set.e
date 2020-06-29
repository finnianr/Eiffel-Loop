note
	description: "JSON name value list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-28 9:40:55 GMT (Sunday 28th June 2020)"
	revision: "8"

class
	JSON_NAME_VALUE_LIST_TEST_SET

inherit
	EL_EQA_REGRESSION_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("parse", agent test_parse)
		end

feature -- Tests

	test_parse
		local
			list: EL_JSON_NAME_VALUE_LIST
		do
			create list.make (Json_text.to_utf_8)
			from list.start until list.after loop
				inspect list.index
					when 1 then
						assert ("valid name", list.name_item_8 ~ "name" and list.value_item ~ My_ching.literal)
						assert ("valid escaped", Escaper.escaped (list.value_item, True) ~ My_ching.escaped)
					when 2 then
						assert ("valid price", list.name_item_8 ~ "price" and list.value_item ~ Price.literal)
						assert ("valid escaped", Escaper.escaped (list.value_item, True) ~ Price.escaped)

				else end
				list.forth
			end
		end

feature {NONE} -- Constants

	Escaper: EL_JSON_VALUE_ESCAPER
		once
			create Result.make
		end

	Json_text: ZSTRING
		once
			Result := "[
				{
					"name" : "\"My Ching\u2122\" \uD852\uDF62",
					"price" : "\u20AC\t3.00"
				}
			]"
		end

	My_ching: TUPLE [literal, escaped: ZSTRING]
		once
			create Result
			Result.literal := {STRING_32} "%"My Ching™%" "
			Result.literal.append_unicode (0x24B62)-- Han character
			Result.escaped := {STRING_32} "\%"My Ching™\%" "
			Result.escaped.append_unicode (0x24B62)-- Han character
		end

	Price: TUPLE [literal, escaped: ZSTRING]
		once
			create Result
			Result.literal := {STRING_32} "€%T3.00"
			Result.escaped := {STRING_32} "€\t3.00"
		end

end
