function mapJSON2Object1(json, object, mapping) {
    var obj;
    
    if (typeof object == 'string') {
        try {
            obj = new this[object]();
        } catch (err) {
            try {
                obj = this[object].new();
            } catch (err2) {
                console.log('ERR1: '+err+', ERR2: '+err2);
            }
        }
    } else {
        obj = new object();
        //obj = Object.create(object.prototype);
    }
    
    var keys = Object.getOwnPropertyNames(obj);
    if (!keys) {
        keys = Object.getOwnPropertyNames(obj.constructor.prototype);
    }
    
    
    // copy stuff over
    for (var i=0;i<keys.length;i++) {
        var k = keys[i];
        if (k == 'constructor') {continue;}
        if (mapping && mapping.hasOwnProperty(k)) {
            obj[k] = json[mapping[k]];
        } else if (json.hasOwnProperty(k)) {
            obj[k] = json[k];
        }
    }
    return obj;
}


function mapJSON2Object(json, object, mapping) {
    if (typeof json == 'string') {
        json = JSON.parse(json);
    }
    
    if (json.constructor == Array) {
        var a = [];
        for (var i=0;i<json.length;i++) {
            a.push(mapJSON2Object1(json[i], object, mapping));
        }
        return a;
    } else {
        return mapJSON2Object1(json, object, mapping);
    }
}