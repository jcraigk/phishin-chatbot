# frozen_string_literal: true
class Commands::Help
  MENU_TEXT = <<~TXT
    ```
    Phish.in' Chatbot Commands
    ============================================================================

    help                    Displays this menu.

    {date} [more]           Sending a date returns show info, including setlist.
                            Appending the keyword "more" displays more detail.
                            Examples: "Jul 31 2013", "1996-12-31 more"

    recent|last [{song}]    Sending the keyword `recent` or `last` returns info
                            from the last show.
                            Appending a song slug or partial title will return
                            the last performance of that song.
                            Examples: "recent", "last Hood", "last blaze-on"
    ```
  TXT

  def call
    MENU_TEXT
  end
end
