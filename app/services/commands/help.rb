# frozen_string_literal: true
class Commands::Help
  MENU_TEXT = <<~TXT
    ```
    Phish.in' Chatbot Commands
    ============================================================================

    help                    Displays this menu.

    {date} [more]           Sending a date returns show info, including setlist.
                            Appending the keyword "more" displays more detail.
                            EX: "1996-12-31", "Jul 31 2013", "July 14 more"

    first, last|recent,     Sending a descriptor returns the matching show.
    shortest, longest,      A song may be requested instead by appending
    random [show|{song}]    a slug or partial title.
                            EX: "recent", "longest Hood", "random blaze-on"
    ```
  TXT

  def call
    MENU_TEXT
  end
end
