const fs=require('fs');
fs.readFile('file.txt','utf8',(error,data)=>{
    console.log(error,data);
})

//note: Finished reading file came after as time taken to read file hence 
//as non blocking its result will displayed later as it will queued for later
// hence carrying on the procedure but if we want to stop it which is block it first then we have to
// use readFilesynch

console.log(fs.readFileSync('file.txt').toString());
console.log('Finished Reading File!');

fs.writeFile('file.txt','YO 2',()=>{
    console.log("Finished Writing!");
});