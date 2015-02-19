var spawn = require('child_process').spawn;

var jobs = setInterval(function(){
	ls = spawn('ruby', ['/Users/linjiapro/Desktop/developPush.rb']);
	ls.stderr.on('data', function(data){
		console.log("error " + data);
	});
	ls.on('close', function(code){
		console.log("execute " + code);
	    });
    }, 10000);


setTimeout(function(){
	clearInterval(jobs);
    }, 1000000);