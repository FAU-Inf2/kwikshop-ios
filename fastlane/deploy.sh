if [ -f "../Kwik Shop.ipa" ]
then
  echo "Uploading ipa"
  scp ../kwikshop.ipa mad:/var/www/hockey/public/de.fau.cs.mad.kwikshop.ios/kwikshop.ipa
else
  echo "Ipa file not found! :-("
fi
