# frozen_string_literal: true
class Commands::Help
  MENU_TEXT = <<~TXT
    ```
    Phish.in' Chatbot Commands
    ============================================================================

    help                    Displays this menu.

    {date} [more]           Sending a date returns show info, including setlist.
                            Appending the keyword "more" displays more detail.
                            Examples: "1996-12-31 more", "Jul 31 2013"

    recent|last [{song}]    Sending `recent` or `last` returns the last show.
                            A song slug or partial title may be appended.
                            Examples: "recent", "last Hood", "last blaze-on"
    ```
  TXT

  def call
    MENU_TEXT
  end
end
