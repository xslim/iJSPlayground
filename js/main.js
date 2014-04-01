var CryptoJS = require('crypto-js')

var Base64 = {
_keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",
encode: function(input) {
    var output = "", chr1, chr2, chr3, enc1, enc2, enc3, enc4, i = 0;
    
    //input = String(input);
    
    while (i < input.length) {
        
        chr1 = input.charCodeAt(i++);
        chr2 = input.charCodeAt(i++);
        chr3 = input.charCodeAt(i++);
        
        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;
        
        if (isNaN(chr2)) {
            enc3 = enc4 = 64;
        } else if (isNaN(chr3)) {
            enc4 = 64;
        }
        
        output = output + this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
        
    }
    return output;
},
encodeFromHex: function(hexx) {
    var hex = hexx.toString();//force conversion
    var str = '';
    for (var i = 0; i < hex.length; i += 2)
        str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
    
    return Base64.encode(str);
}
};

function hex2a(hexx) {
    
    return str;
}

function bl_gen_token(token, tokenId, accessKey, secretKey, apiVersion, stamp) {
    var timestamp = stamp || Date.now();
    
    var baseSignature = '' + secretKey + timestamp;
    var header = '' + tokenId + ' k="' + accessKey + '",tm="' + timestamp + '"';
    
    if (token.length > 0) {
        header += ',t="' + token + '"';
        baseSignature += token;
    }
    
    var signature = CryptoJS.HmacSHA1(baseSignature, secretKey);
	var hash = Base64.encodeFromHex(signature);
    
    header += ',s="' + hash + '"'
    header += ',v="' + apiVersion + '"'
    return header
}

var ping = function () {
    console.log("requesting ping");
    return "PONG";
}

function base64_encode(x) {
    return Base64.encode(x);
}

function crypto_HmacSHA1(data, key) {
    return CryptoJS.HmacSHA1(data, key);
}
