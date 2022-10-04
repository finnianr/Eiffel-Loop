note
	description: "Test [$source EL_SUBSTITUTION_TEMPLATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 8:51:13 GMT (Tuesday 4th October 2022)"
	revision: "7"

class
	SUBSTITUTION_TEMPLATE_TEST_SET

inherit
	EL_EQA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("string_substitution",			agent test_string_substitution)
			eval.call ("zstring_substitution",			agent test_zstring_substitution)
			eval.call ("object_field_substitution",	agent test_object_field_substitution)
		end

feature -- Tests

	test_string_substitution
		local
			template: EL_STRING_8_TEMPLATE
		do
			create template.make (Template_string)
			template.set_variables_from_array (<<
				[Var_price, 5], [Var_quantity, 10]
			>>)
			assert ("correct ", template.substituted ~ Price_5_quanity_10.to_latin_1)
		end

	test_zstring_substitution
		local
			template: EL_ZSTRING_TEMPLATE
		do
			create template.make (Template_string)
			template.set_variables_from_array (<<
				[Var_price, 5], [Var_quantity, 10]
			>>)
			assert ("correct", template.substituted ~ Price_5_quanity_10)
		end

	test_object_field_substitution
		local
			ireland: COUNTRY; template: EL_ZSTRING_TEMPLATE
		do
			create ireland.make_default
			ireland.set_name ("Ireland")
			ireland.set_code ("ie")
			ireland.set_population (4_766_073)
			create template.make (Template_country)
			across 1 |..| 2 as n loop
				template.set_variables_from_object (ireland)
				assert ("correct ", template.substituted ~ Ireland_info)
			end
		end

feature {NONE} -- Constants

	Var_price: STRING = "price"

	Var_quantity: ZSTRING
		once
			Result := "quantity"
		end

	Template_string: STRING = "Price: ${price} Quantity: $quantity"

	Price_5_quanity_10: ZSTRING
		once
			Result := "Price: 5 Quantity: 10"
		end

	Ireland_info: ZSTRING
		once
			Result := "Country: Ireland; Code: ie; Population: 4766073"
		end

	Template_country: ZSTRING
		once
			Result := "Country: $name; Code: $code; Population: $population"
		end
end