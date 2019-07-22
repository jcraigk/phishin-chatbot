# frozen_string_literal: true
class Commands::Help
  MENU_TEXT = <<~TXT
    ```
    Phish.in' Chatbot Commands
    ===========================================================================

    help                Displays this menu.

    {date} [more]       Providing a date returns show info, including  setlist.
                        Appending the keyword "more" displays more detail.
                        Examples: "Jul 31 2013", "1996-12-31 more"
    ```
  TXT

  def call
    MENU_TEXT
  end
end
