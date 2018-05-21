note
	description: "Reflective test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "2"

class
	REFLECTIVE_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_LOG
		undefine
			default_create
		end

	EL_REFLECTION_HANDLER
		undefine
			default_create
		end

feature -- Tests

	test_reflection
		local
			table: HASH_TABLE [STRING_32, STRING]
			object: MY_DRY_CLASS
		do
			log.enter ("test_reflection")
			create object.make_default
			create table.make_equal (object.field_table.count)
			across object.field_table as field loop
				if field.key ~ "boolean" then
					table [field.key] := "True"
				else
					table [field.key] := field.cursor_index.out
				end
			end
			create object.make (table)
			assert ("table ~ object.data_export", table ~ object.data_export)
			log.exit
		end

	test_json_reflection
		local
			currency, euro: JSON_CURRENCY
		do
			log.enter ("test_serialization")
			create euro.make ("Euro", {STRING_32}"€", "EUR")
			create currency.make_from_json (euro.as_json)
			assert ("same value", euro ~ currency)
			log.exit
		end
end
