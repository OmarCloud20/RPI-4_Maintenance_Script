# This is script is to keep the Raspberry Pi Ubuntu OS up to date
# The script is running every week on Sunday at 3 am CST


# Set the variable $admin_email as your email address.
admin_mail="xxxxxxx@gmail.com"                                                                                             
# Create a temporary path in /tmp to write a temporary log
# file. No need to edit.
tmpfile=$(mktemp)


# Run the commands to update the system and write the log
# file at the same time.
echo "aptitupde update" >> ${tmpfile}
aptitude update >> ${tmpfile} 2>&1
echo "" >> ${tmpfile}
echo "aptitude safe-upgrade" >> ${tmpfile}
aptitude -y safe-upgrade >> ${tmpfile} 2>&1
echo "" >> ${tmpfile}
echo "aptitude clean" >> ${tmpfile}
aptitude clean >> ${tmpfile} 2>&1

# Send the temporary log via mail. The fact if the upgrade
# was succesful or not is written in the subject field.
if grep -q 'E: \|W: ' ${tmpfile} ; then
        mail -s "RPI-4 upgrade has failed on $(date)" ${admin_mail} < ${tmpfile}
else
        mail -s "RPI-4 upgrade is succesfully completed on $(date)" ${admin_mail} < ${tmpfile}
fi

# Remove the temporary log file in temporary path.
rm -f ${tmpfile}
