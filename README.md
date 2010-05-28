# AQL SMS API

A ruby wrapper for the AQL SMS API. I am building this for use in a specific project, nothing more. If you feel it can be enhanced and devloped then please feel free to fork away.

## Usage

#### Authentication

    # @params username, password [, originator]
    #
    AQL::SMS.authenticate "username", "password"

#### Check credit

    # @return integer number of credits
    #
    AQL::SMS.check_credit

#### Send message

    # @params desitnation, message [, options]
    #   destination can be single number string or array of multiple numbers
    #   options can be hash of :originator, :max_concat, :sendtime, :unix_sendtime, :replace_sms, :flash, :dlr_url
    #
    AQL::SMS.send_message "07777 777 777", "R U coming rnd 2 mine 2nite?"

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Aaron Russell. See LICENSE for details.
