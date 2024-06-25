const p=require('node:events');
var x=new p();
x.addListener('Message Logged!',(arg)=>{
    console.log('Listener Called!');
    console.log(arg);
})
x.emit('Message Logged!',{id:1 ,url:'xc'});
x.emit('Message Logged!',{date:'Messi'})