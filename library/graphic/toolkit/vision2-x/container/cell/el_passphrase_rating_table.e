note
	description: "Table displaying passphrase attributes and security rating score"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-08 18:32:44 GMT (Tuesday 8th September 2020)"
	revision: "1"

class
	EL_PASSPHRASE_RATING_TABLE

inherit
	EL_VERTICAL_BOX
		rename
			make as make_box
		redefine
			create_interface_objects
		end

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_GUI

	EL_MODULE_VISION_2

create
	make

feature {NONE} -- Initialization

	make (a_field: like field; a_new_label: like new_label; a_checked_image_path: EL_FILE_PATH)
		do
			field := a_field; new_label := a_new_label; checked_image_path := a_checked_image_path

			field.on_change.add_action (agent on_field_change)
			make_box (0, 0.2)

			phrase_attributes := field.new_phrase_attributes
			from phrase_attributes.start until phrase_attributes.after loop
				extend_unexpanded (
					Vision_2.new_horizontal_box (0, 0.3, <<
						create {EV_CELL},
						new_label (phrase_attributes.item_attribute),
						create {EL_EXPANDED_CELL},
						check_list [phrase_attributes.index]
					>>)
				)
				phrase_attributes.forth
			end
			extend_unexpanded (
				Vision_2.new_horizontal_box (0, 0.3, <<
					create {EV_CELL}, score_label, create {EL_EXPANDED_CELL}, secure_enough_check
				>>)
			)
		end

feature -- Status query

	minimum_score_met: BOOLEAN
		do
			Result := phrase_attributes.score >= 4
		end

feature {NONE} -- Event handlers

	on_field_change
			--
		do
			phrase_attributes := field.new_phrase_attributes

			score_label.set_text (Score_template #$ [phrase_attributes.score])
			secure_enough_check.set_checked (minimum_score_met)

			from phrase_attributes.start until phrase_attributes.after loop
				check_list.i_th (phrase_attributes.index).set_checked (phrase_attributes.item_has_attribute)
				phrase_attributes.forth
			end
		end

feature {NONE} -- Implementation

	create_interface_objects
		local
			check_width: INTEGER; bold_font: EV_FONT
		do
			Precursor
			score_label := new_label (Score_template #$ [0])
			bold_font := score_label.font.twin
			bold_font.set_weight (Gui.Weight_bold)
			score_label.set_font (bold_font)
			check_width := (score_label.height * 1.7).rounded
			create check_list.make (6)
			from until check_list.full loop
				check_list.extend (new_check_area (check_width))
			end
			secure_enough_check := new_check_area (check_width)
		end

	new_check_area (a_width: INTEGER): EL_CHECK_AREA
		do
			create Result.make (checked_image_path, a_width)
		end

feature {NONE} -- Internal attributes

	check_list: ARRAYED_LIST [EL_CHECK_AREA]

	checked_image_path: EL_FILE_PATH

	field: EL_PASSPHRASE_FIELD

	new_label: FUNCTION [READABLE_STRING_GENERAL, EL_LABEL]

	phrase_attributes: EL_PASSPHRASE_ATTRIBUTE_LIST

	score_label: EV_LABEL

	secure_enough_check: EL_CHECK_AREA

feature {NONE} -- Constants

	Score_template: ZSTRING
		once
			Locale.set_next_translation ("Passphrase strength (%S / 6)")
			Result := Locale * "{passphrase-strength}"
		end

end
