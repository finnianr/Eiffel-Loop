note
	description: "Routines to test localization keys present"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-24 9:32:26 GMT (Friday 24th September 2021)"
	revision: "1"

deferred class
	EL_LOCALIZATION_TEST

inherit
	EL_MODULE_LIO

	EL_MODULE_EIFFEL

	EL_MODULE_LOCALE

feature -- Tests

	test_reflective_locale_texts
		-- call `check_reflective_locale_texts' in descendant test set
		deferred
		end

feature {NONE} -- Implementation

	assert (a_tag: STRING; a_condition: BOOLEAN)
		deferred
		end

	assert_valid_tuple (name: STRING; a_tuple: TUPLE; key_list: READABLE_STRING_GENERAL)
		do
			assert ("valid " + name + " tuple", Locale.valid_tuple (a_tuple, key_list))
		end

	check_reflective_locale_texts
		local
			texts: EL_REFLECTIVE_LOCALE_TEXTS
		do
			across new_text_type_list as type loop
				if attached {EL_REFLECTIVE_LOCALE_TEXTS} Eiffel.new_object (type.item) as new then
					new.make
					texts := new
				end
				if attached texts.missing_keys_list as not_found_list then
					across not_found_list as list loop
						lio.put_labeled_substitution (texts.generator, "localization key %"%S%" not found", [list.item])
					end
					assert ("All translation keys found", False)
				else
					lio.put_labeled_string (texts.generator, "All keys OK")
					lio.put_new_line
				end
				assert ("Valid English table", texts.valid_english_table)
			end
		end

	locale_texts_types: TUPLE
		-- tuple of types conforming to `EL_REFLECTIVE_LOCALE_TEXTS'
		deferred
		ensure
			all_conform: new_text_type_list.all_conform
		end

	new_text_type_list: EL_TUPLE_TYPE_LIST [EL_REFLECTIVE_LOCALE_TEXTS]
		do
			create Result.make_from_tuple (locale_texts_types)
		end

end