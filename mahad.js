const express = require('express');
const mysql = require('mysql2');
const app = express();
var bodyparser = require('body-parser');
// var tempstorage = require("sessionstorage-for-nodejs");
// tempstorage.setItem("userid", 1);
// tempstorage.setItem("teamid", 1);
app.use(bodyparser.json());
app.use(bodyparser.urlencoded({ extended: true }));
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'mahad123',
    database: 'playshare'
});

db.connect((error) => {
    if (error) {
        console.log(error);
    };
    console.log("Connected!");
    // //db.query('SELECT* FROM Team',(error,res)=>
    // {
    //     if(!error)
    //         {
    //             console.log(res);
    //         }
    // })
});
app.use(express.static(__dirname, { extensions: ["png", "jpg", "svg"], }))
app.get('/Payment', (req, res) => {
    res.sendFile(__dirname + '/payment.html');
});
app.post('/Payment', (req, res) => {

    var date = req.body.D1;
    var bankfrom = req.body.a1;
    console.log(req.body.selectedPaymentMethod);
    db.connect((error) => {




        // db.query('call pamin(?,?,?,?,?,?)',[date,1000,'sadapay',bankfrom,1,1],(error,result)=>
        //     {
        //         if(error)
        //             {
        //                 console.log(error);
        //             }
        //   res.redirect('/sign');

        //});
    })

    // db.query('INSERT INTO Test VALUES('+req.body.N1+')');
})
app.set('view engine', 'ejs');
app.use(express.static(__dirname, { extensions: ["png", "jpg", "svg"], }))
app.get('/torreg', (req, res) => {
    db.connect((error) => {
        if (error) console.log("error");
        db.query("SELECT name FROM Field", (error, result) => {
            res.render(__dirname + '/torreg', { f: result });
            console.log("result");
        })
    })
});

app.get('/team', (req, res) => {
    db.connect((error) => {
        if (error) console.log("error");
        db.query("SELECT name FROM Team", (error, result) => {
            res.render(__dirname + '/team', { f: result });
            console.log("result");
        })
    })
});
app.post('/team', function (req, res) {

    console.log(req.body);
    //var id = tempstorage.getItem('userid');
    var id = 1;
    var name = req.body.N2;
    var team = req.body.team;
    var flag = 0;

    db.connect((error) => {

        if (team === 'NULL') {
            db.query('CALL insertteam(?,?)', [name, id], (error, result) => {
                if (error) {
                    console.log(error);
                }
                console.log(1);

            });
        }
        else {
            db.query('CALL addteam(?,?,?)', [team, id, flag], (error, result) => {
                console.log(2);
                if (error) {
                    console.log(error);
                }

            });

        }
    })
});

app.post('/torreg', (req, res) => {
    console.log("yo");
    var name = req.body.N1;
    var Date = req.body.D1;
    var Duration = req.body.T1;
    var sports = req.body.s;
    var noofteams = req.body.M1;
    var location = req.body.Fieldname;
    db.connect((error) => {
        db.query('CALL inserttournament(?,?,?,?,?)', [name, location, noofteams, Duration, Date], (error, result) => {
            if (error) {
                console.log(error);
            }

        });
    })
})
app.get('/home', (req, res) => {
    res.sendFile(__dirname + '/home.html');
});

// Route to serve signup form
app.get('/sign', (req, res) => {
    //var flag=0;+
    res.render(__dirname + "/sign", { s: 0 });

});
// Route to handle form submission
app.post('/sign', function (req, res) {

    var sp;


    switch (req.body.sport) {
        case 'Cricket':
            sp = 2;
            break;
        case 'Football':
            sp = 1;
            break;
        case 'Basketball':
            sp = 4;
            break;
        case 'Tennis':
            sp = 3;
            break;
    }


    var name = req.body.fullname;
    var uname = req.body.username;
    var pass = req.body.password;
    var phone = req.body.phone;
    var email = req.body.email;
    var gender = req.body.mygender;

    db.query('CALL UserSignup(?, ?, ?, ?, ?, ?, ?, @Flag)', [name, uname, pass, sp, phone, email, gender], function (err, result) {
        if (err) {
            console.error('Error calling stored procedure:', err);
            return;
        }
        console.log(req.body);
        // Get the value of the output flag
        db.query('SELECT @Flag AS flag', function (err, rows) {
            if (err) {
                console.error('Error retrieving output flag:', err);

            }
            flag = rows[0].flag;

            console.log(flag);

            // Perform different tasks based on the value of the output flag
            switch (flag) {
                case 0:
                    console.log('Signup successful');
                    res.redirect('/home');
                    break;
                case 1:
                    console.log('Username already taken');
                    res.render(__dirname + "/sign", { s: flag });

                    break;
                case 2:
                    console.log('Gmail already taken');
                    res.render(__dirname + "/sign", { s: flag });

                    break;
                case 3:
                    console.log('User with this contact already exists');
                    res.render(__dirname + "/sign", { s: flag });
                    break;
                default:
                    console.log('Unknown error');
                    break;
            }
        });
    });
});

app.get('/feed', (req, res) => {

    db.query('select* from feed', function (err, result) {
        if (err) {
            console.error('Error calling stored procedure : ', err);
        }
        console.log(result);
        res.render(__dirname + '/feed', { f: result });



    })
})
app.get('/rewards', (req, res) => {

    db.query('CALL rewards(?,@Flag)', [1], function (err, result) {
        if (err) {
            console.error('Error calling stored procedure : ', err);

        }
        db.query('SELECT @Flag AS flag', function (err, rows) {
            if (err) {
                console.error('Error retrieving output flag:', err);

            }
            var flag = rows[0].flag;
            console.log(flag);

            res.render(__dirname + '/rewards', { l: flag });
        });
    })
});
app.get('/lg', (req, res) => {
    res.render(__dirname + '/lg', { l: 0 });
});
// Route to handle form submission
app.post('/lg', function (req, res) {



    db.query('CALL Login(?,?,@Flag)', [req.body.user, req.body.pass], function (err, result) {
        if (err) {
            console.error('Error calling stored procedure : ', err);
        }
        console.log(req.body);

        db.query('SELECT @Flag AS flag', function (err, rows) {
            if (err) {
                console.error('Error retrieving output flag:', err);

            }
            var flag = rows[0].flag;
            console.log(flag);


            switch (flag) {

                case 0:
                    console.log("Successfull signin");
                    res.redirect('/home');
                    break;
                case 1:
                    console.log("Incorrect password");
                    res.render(__dirname + '/lg', { l: flag });
                    break;
                case 2:
                    console.log("User not found");
                    res.render(__dirname + '/lg', { l: flag });
                    break;
                default:
                    counsole.log("unknows error");
                    res.render(__dirname + '/lg', { l: flag });
                    break;
            }

        })
    })

});



app.listen(3000, () => console.log('Server Started'));