// Networking check script to help to understand "Dave" working

/*

BASH $ hostname
CMD $ ping localhost
CMD $ nslookup IP

*/
var os = require("os"), dns = require("dns");
var host = os.hostname();
console.log(host);

// But, when dave is running using asyc, it resolves DIFFERENT hostname somewhere here
//dns.lookup(host);
