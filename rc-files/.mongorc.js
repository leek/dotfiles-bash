DBQuery.prototype._prettyShell = true

states = ["STARTUP", "PRIMARY", "SECONDARY", "RECOVERING", "FATAL", "STARTUP2", "UNKNOWN", "ARBITER", "DOWN", "ROLLBACK"]

host = db.serverStatus().host.split('.')[0]

getPrimaryOptimeDate = function() {
    if (rs.status().members) {
        var members = rs.status().members;
        for (var i = 0; i < members.length; i++) {
            var member = members[i];
            if (member['stateStr'] == 'PRIMARY') {
                return member['optimeDate'];
            }
        }
    }
}

getMyOptimeDate = function() {
    if (rs.status().members) {
        var members = rs.status().members;
        for (var i = 0; i < members.length; i++) {
            var member = members[i];
            if (member['self']) {
                return member['optimeDate'];
            }
        }
    }
}

getReplicationLag = function() {
    return ((getPrimaryOptimeDate() - getMyOptimeDate()) / 1000);
}

summary = function() {
    var uptime = db.serverStatus().uptime;
    if (db.serverStatus().repl) {
        var setName = db.serverStatus().repl.setName;
        var primary = db.serverStatus().repl.primary;
    } else {
        var setName = false;
        var primary = false;
    }
    var replag = getReplicationLag();
    var curConnections = db.serverStatus().connections.current;
    var resMem = db.serverStatus().mem.resident;
    var userAsserts = db.serverStatus().asserts.user;
    var warningAsserts = db.serverStatus().asserts.warning;
    var totalQueues = db.serverStatus().globalLock.currentQueue.total;
    var lockRatio = db.serverStatus().globalLock.ratio || 0;
    var readQueues = db.serverStatus().globalLock.currentQueue.readers;

    print('\n\tSystem information as of ' + db.serverStatus().localTime)

    if (primary) {
        print('\n\t** Replication **');
        print("\tPrimary: " + primary + "\tReplag: " + replag + ' (s)');
    }

    print('\n\t** Uptime **');
    var uptimeHours = Math.floor(uptime / (60 * 60));
    var uptimeMinutes = Math.floor((uptime - (uptimeHours * 60 * 60)) / 60);
    print("\tuptime: " + uptime + ' (s)' + '\thuman: ' + uptimeHours + 'h' + ' and ' + uptimeMinutes + 'm');

    print('\n\t** Connections **');
    print("\tCurrent: " + curConnections + "\tQueued: " + totalQueues + "\t% read:" + readQueues / (totalQueues + 1) + "\tLock Ratio: " + lockRatio);

    print('\n\t** Asserts **');
    print("\tUser: " + userAsserts + "\tWarning: " + warningAsserts);
    print('');
}
summary();

prompt = function() {
    // result = db.isMaster();
    // if (result.ismaster) {
    //     var state = 'P';
    // } else if (result.secondary) {
    //     var state = 'S';
    // } else {
    //     result = db.adminCommand({
    //         replSetGetstate: 1
    //     })
    //     var state = states[result.myState];
    // }
    return host + ':' + db + '> ';
}
