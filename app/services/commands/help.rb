# frozen_string_literal: true
class Commands::Help
  MENU_TEXT = <<~TXT
    ```
    Phish.in' Chatbot Commands
    ============================================================================

    help                    Displays this menu.

    {date} [more]           Sending a date returns show info and setlist.
                            Appending the keyword "more" displays more detail.
                            EX: "1996-12-31", "Jul 31 2013", "July 14 more"

    first, last|recent,     Sending a descriptor returns the requested show
    shortest, longest,      or song if slug or partial title is appended.
    random [show|{song}]    EX: "recent", "longest Hood", "random blaze-on"

    jamchart [{song}]       Sending `jamchart` returns a random Jamchart,
                            optionally constrained to a specific song.
                            EX: "jamchart", "jamchart tweezer"
    ```
  TXT

  def call
    MENU_TEXT
  end
end
