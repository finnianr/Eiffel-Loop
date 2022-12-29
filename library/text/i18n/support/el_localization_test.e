note
	description: "Routines to test localization keys present"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-29 10:07:10 GMT (Thursday 29th December 2022)"
	revision: "7"

deferred class
	EL_LOCALIZATION_TEST

inherit
	EL_MODULE_LIO

	EL_MODULE_EIFFEL

	EL_MODULE_LOCALE

	EL_REFLECTION_HANDLER
		undefine
			default_create
		end

feature {NONE} -- Deferred

	assert (a_tag: STRING; a_condition: BOOLEAN)
		deferred
		end

	assert_same_string (tag: detachable STRING; a, b: READABLE_STRING_GENERAL)
		deferred
		end

	locale_texts_types: TUPLE
		-- tuple of types conforming to `EL_REFLECTIVE_LOCALE_TEXTS'
		deferred
		ensure
			all_conform: new_text_type_list.all_conform
		end

	test_reflective_locale_texts
		-- call `check_reflective_locale_texts' in descendant test set
		deferred
		end

feature {NONE} -- Implementation

	assert_valid_tuple (name: STRING; a_tuple: TUPLE; key_list: READABLE_STRING_GENERAL)
		do
			assert ("valid " + name + " tuple", Locale.valid_tuple (a_tuple, key_list))
		end

	assert_all_keys_ok (texts: EL_REFLECTIVE_LOCALE_TEXTS)
		do
			if attached texts.missing_keys_list as not_found_list then
				across not_found_list as list loop
					lio.put_labeled_substitution (texts.generator, "localization key %"%S%" not found", [list.item])
				end
				assert ("All translation keys found", False)
			else
				lio.put_labeled_string (texts.generator + " " + texts.language, "keys OK")
				lio.put_new_line
			end
			assert ("Valid English table", texts.valid_english_table)
			assert ("Valid special keys", texts.valid_special_keys)
		end

	assert_consistent_translation (texts, translated_texts: EL_REFLECTIVE_LOCALE_TEXTS)
		-- German consistent with English in substitution templates etc
		local
			field: EL_REFLECTED_FIELD; quantity, translated_quantity: EL_QUANTITY_TEMPLATE
			place_count, translated_place_count, i: INTEGER
			quantity_keys, translated_quantity_keys: SORTABLE_ARRAY [READABLE_STRING_8]
		do
			assert_all_keys_ok (translated_texts)
			across texts.field_table as table loop
				if attached new_quanity (texts, field) as new then
					quantity := new
					translated_quantity := new_quanity (translated_texts, field)
					across quantity as template loop
						i := template.cursor_index
						create quantity_keys.make_from_array (template.item.variable_values.current_keys)
						quantity_keys.compare_objects; quantity_keys.sort
						create translated_quantity_keys.make_from_array (
							translated_quantity [i].variable_values.current_keys
						)
						translated_quantity_keys.compare_objects; translated_quantity_keys.sort
						assert ("same quantity keys", quantity_keys ~ translated_quantity_keys)
					end

				elseif attached {EL_REFLECTED_ZSTRING} table.item as zstring_field then
					field := translated_texts.field_table [table.key]
					if attached {EL_REFLECTED_ZSTRING} field as translated_zstring_field then
						place_count := zstring_field.value (texts).occurrences ('%S')
						translated_place_count := translated_zstring_field.value (translated_texts).occurrences ('%S')
						if place_count /= translated_place_count then
							lio.put_labeled_string (table.key, "Inconsistent # place holder count")
							lio.put_new_line
							assert ("same %S occurrences", False)
						end
					end
				end
			end

		end

	check_reflective_locale_texts
		local
			default_texts, texts: EL_REFLECTIVE_LOCALE_TEXTS
			default_locale: EL_DEFERRED_LOCALE_IMP; text_field: STRING; field: EL_REFLECTED_FIELD
		do
			create default_locale.make
			across new_text_type_list as type loop
				texts := new_locale_text (type.item, Locale)
				across Locale.all_languages as language loop
					if texts.language ~ language.item then
						default_texts := new_locale_text (type.item, default_locale)
						across texts.field_table as table loop
							text_field := table.key; field := table.item
							if not attached new_quanity (texts, field)
								and then field.value (texts) /~ field.value (default_texts)
							then
								if attached {READABLE_STRING_GENERAL} field.value (texts) as general
									and then attached {READABLE_STRING_GENERAL} field.value (default_texts) as default_general
								then
									lio.put_new_line
									lio.put_labeled_string (texts.generator, field.name)
									lio.put_new_line
									display_difference (general, default_general)
								end
								assert ("same field values", False)
							end
						end
					else
						-- German consistent with English etc
						assert_consistent_translation (texts, new_locale_text (type.item, Locale.in (language.item)))
					end
				end
				assert_all_keys_ok (texts)
			end
		end

	display_difference (a_text_value, a_default_value: READABLE_STRING_GENERAL)
		local
			text_value, default_value: EL_ZSTRING_LIST; lines_differ: BOOLEAN
			index: INTEGER; s: EL_STRING_8_ROUTINES
		do
			create text_value.make_with_lines (a_text_value)
			create default_value.make_with_lines (a_default_value)
			across text_value as line until lines_differ loop
				index := line.cursor_index
				if not default_value.valid_index (index) or else line.item /~ default_value [index] then
					lines_differ := True
				end
			end
			across << text_value, default_value >> as value loop
				lio.put_new_line
				if value.cursor_index = 1 then
					lio.put_line ("Pyxis file")
				else
					lio.put_line ("English_text")
				end
				lio.put_line (s.n_character_string ('-', 100))
				across value.item as line loop
					if index >= line.cursor_index then
						lio.put_line (line.item)
					end
				end
				lio.put_line (s.n_character_string ('-', 100))
			end
		end

	new_quanity (object: EL_REFLECTIVE; field: EL_REFLECTED_FIELD): detachable EL_QUANTITY_TEMPLATE
		do
			if attached {EL_REFLECTED_REFERENCE [ANY]} field as ref
				and then attached {EL_QUANTITY_TEMPLATE} field.value (object) as template
			then
				Result := template
			end
		end

	new_text_type_list: EL_TUPLE_TYPE_LIST [EL_REFLECTIVE_LOCALE_TEXTS]
		do
			create Result.make_from_tuple (locale_texts_types)
		end

	new_locale_text (type: TYPE [EL_REFLECTIVE_LOCALE_TEXTS]; a_locale: EL_DEFERRED_LOCALE_I): EL_REFLECTIVE_LOCALE_TEXTS

		do
			if attached {EL_REFLECTIVE_LOCALE_TEXTS} Eiffel.new_object (type) as new then
				new.make_with_locale (a_locale)
				Result := new
			end
		end

end