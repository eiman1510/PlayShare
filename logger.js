var url='http://mylogger.io/log';
function log(message)
{
    console.log(message);
}
console.log(__filename);
console.log(__dirname);
module.exports=log;