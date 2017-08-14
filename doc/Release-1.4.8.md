# Eiffel-Loop (1.4.8)  released 14th August 2017

## BASE library

* Added deferred attribute `date_text: EL_DATE_TEXT` to class `EL_DEFERRED_LOCALE_I`. By default it is implemented as `EL_ENGLISH_DATE_TEXT`.

* Added new class `EL_SPLIT_ZSTRING_LIST` which implements a more efficient way to process split strings as it doesn't create a new string instance for each split part.

* Added routines `do_with_splits`, `for_all_split`, and `there_exists_split` to class `EL_ZSTRING` for efficiently querying and processing split strings. These routines make use of the new class `EL_SPLIT_ZSTRING_LIST`.

## APP-MANAGE library

* Created sub-application class `EL_CHECK_LOCALE_STRINGS_APP` to scan an Eiffel source code tree and verify that every locale string identifier for a particular language has an entry in the application localization file. (Assumes Eiffel-Loop localization conventions)

## SERVLET library

* Updated agent syntax to the simplified form.

## VISION2-X library

* Removed dependency on `i18n.ecf` library so that localization implementation is optional. Components prefixed with `EL_LOCALE_` default to English if localization is not implemented.

* Created classes `EL_INFORMATION_DIALOG` and `EL_CONFIRMATION_DIALOG` with button and title texts that can be optionally localized using the `i18n.ecf` library. These replace classes `EL_LOCALE_INFORMATION_DIALOG` and `EL_LOCALE_CONFIRMATION_DIALOG`.

* Merged `EL_LOCALE_SCROLLABLE_SEARCH_RESULTS` and `EL_SCROLLABLE_SEARCH_RESULTS`.

* Updated agent syntax to the simplified form.

* Renamed `EL_STYLED_ZSTRING` as `EL_STYLED_TEXT`.

* Renamed `EL_MONOSPACED_STYLED_ZSTRING` as `EL_MONOSPACED_STYLED_TEXT`.

* Changed `EL_STYLED_TEXT` so it no longer inherits from EL_ZSTRING and can be initialized by any string conforming to `READABLE_STRING_GENERAL`. Added routines: `prepend_space`, `remove_last_word` and `leading_spaces_width`.

* Changed `EL_HYPERLINK_AREA` so it can be initialized by any string conforming to `READABLE_STRING_GENERAL`.

* Changed type of `EL_COLOR_BUTTON.title_text` to `READABLE_STRING_GENERAL`.

* Changed string arguments of routine `EL_MULTI_MODE_HTML_COLOR_SELECTOR_BOX.make` to type `READABLE_STRING_GENERAL`.

* Changed type of `MINI_TAG_PIXMAP.title` to `READABLE_STRING_GENERAL`.

* Optimized `{EL_VISION_2_GUI_ROUTINES_I}.is_word_wrappable` to minimize string creation by using `{EL_ZSTRING}.split_intervals`
