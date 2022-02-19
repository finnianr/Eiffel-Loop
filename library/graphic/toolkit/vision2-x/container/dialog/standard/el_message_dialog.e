note
	description: "Message dialog with deferred localization text from [$source EL_WORD_TEXTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 12:38:23 GMT (Saturday 19th February 2022)"
	revision: "10"

class
	EL_MESSAGE_DIALOG

inherit
	EV_MESSAGE_DIALOG
		rename
			add_button as add_locale_button,
			button as locale_button
		export
			{ANY} label
		redefine
			add_locale_button, locale_button, set_text, set_title
		end

	EL_SHARED_WORD

feature {NONE} -- Initialization

	make_with_template (template: READABLE_STRING_GENERAL; inserts: TUPLE)
		local
			s: EL_ZSTRING_ROUTINES
		do
			make_with_text (s.as_zstring (template).substituted_tuple (inserts).to_unicode)
		end

feature -- Element change

	set_label_font (a_font: EL_FONT)
		do
			label.set_font (a_font)
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			Precursor (s.to_unicode_general (a_text))
		end

	set_title (a_title: separate READABLE_STRING_GENERAL)
		do
			if attached {STRING} a_title as key and then Title_text_table.has_key (key) then
				Precursor (Title_text_table.found_item.to_unicode)
			else
				Precursor (a_title)
			end
		end

feature {NONE} -- Implementation

	add_locale_button (a_text: READABLE_STRING_GENERAL)
		do
			Precursor (new_button_text (a_text))
		end

	locale_button (a_text: READABLE_STRING_GENERAL): EV_BUTTON
		do
			Result := Precursor (new_button_text (a_text))
		end

	new_button_text (a_text: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if attached {STRING} a_text as key and then Button_text_table.has_key (key) then
				Result := Button_text_table.found_item.to_unicode
			else
				Result := a_text
			end
		end

feature {NONE} -- Constants

	Button_text_table: EL_HASH_TABLE [ZSTRING, STRING]
		once
			create Result.make (<<
				["Apply", Word.apply],
				["Discard", Word.discard],

				[ev_abort, Word.abort],
				[ev_cancel, Word.cancel],
				[ev_ignore, Word.ignore],
				[ev_no, Word.no],
				[ev_ok, Word.OK],
				[ev_open, Word.open],
				[ev_print, Word.print],
				[ev_retry, Word.retry_],
				[ev_save, Word.save],
				[ev_yes, Word.yes]
			>>)
		ensure
			all_present: across Name_list as name all Result.has (name.item) end
		end

	Name_list: ARRAY [STRING]
		once
			Result := <<
				ev_abort, ev_cancel, ev_ignore, ev_no, ev_ok, ev_open, ev_print, ev_retry, ev_save, ev_yes
			>>
		end

	Title_text_table: EL_HASH_TABLE [ZSTRING, STRING]
		once
			create Result.make (<<
				[ev_confirmation_dialog_title, Word.confirmation],
				[ev_error_dialog_title, Word.error],
				[ev_information_dialog_title, Word.information],
				[ev_question_dialog_title, Word.question],
				[ev_warning_dialog_title, Word.warning]
			>>)
		end
end