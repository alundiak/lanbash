#!/bin/bash

# https://www.binarytides.com/linux-mailx-command/
# https://tecadmin.net/ways-to-send-email-from-linux-command-line/
# https://unix.stackexchange.com/questions/200222/set-sender-name-in-mail-function

# katarzyna.puczko92@gmail.com
# echo "Hello Pelcia" | mail -s "the very test" landike@gmail.com

#echo "Hello" | sendmail -f landike@gmail.com

# mail -s 'Some Subject' -r 'Andrzej Lundiak <alundiak@example.com>' landike@gmail.com

# mail -a FROM:alundiak@example.com landike@gmail.com
#mailx --append="FROMalundiak@example.com" landike@gmail.com


# echo "test 2" | mail -f alundiak@example.com -s "subject" landike@gmail.com 
# echo "test 4" | mail -s "subject" landike@gmail.com  -- -f alundiak@example.com
# echo "test" | mail -s "subject 3" landike@gmail.com  -- -F "Andrii Lundiak" -f 'alundiak@example.com'
# echo "test 5" | mail -s "subject" andike@gmail.com -- -F'A L<alundiak@example.com>' -t

#mutt -e "set from='name <alundiak@example.com>'

# echo "This is the body" | mail -s "Subject" -aFrom:AndriiL\<alundiak@example.com\> landike@gmail.com
# illegal option a

# echo "body" | mail -S from=alundiak@example.com "Hello"
# illegla S

# https://stackoverflow.com/questions/54725/change-the-from-address-in-unix-mail/8483239#8483239
# Works FROM
export EMAIL=alundiak@example.com # FROM
export REPLYTO=landike@outlook.com
mutt -s TestingMutt katarzyna.puczko92@gmail.com

# maybe sendmail
# https://superuser.com/questions/351841/how-do-i-set-up-the-unix-mail-command
