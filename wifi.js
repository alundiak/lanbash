var wifiPassword = require('wifi-password');

wifiPassword(function (err, password) {
    console.log(password);
    //=> should be 'johndoesecretpassword'
});


wifiPassword("rac_szw", function(){
  console.log("WAT ??");
});