const express = require('express');
const mysql = require('mysql2');
var app = express();
var bodyparser = require("body-parser");
var tempstorage = require("sessionstorage-for-nodejs");
app.use(bodyparser.json());
app.use(bodyparser.urlencoded({ extended: true }));
app.set('view engine', 'ejs');
app.use(express.static(__dirname, { extensions: ["png", "jpg", "svg"], }))
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '12345678',
    database: 'Final2'
});

db.connect((error) => {
    if (error) {
        console.log(error);
    };
    console.log("Connected!");
});
//goat work starts

//Team Registration + Team Association Handled
app.get('/team', (req, res) => {

    db.connect((error) => {

        if (error) console.log("error");
        var sp = tempstorage.getItem('psports');
        console.log(sp);
        db.query("SELECT name FROM Team where sportstype=?", [sp], (error, result) => {
            console.log(result);
            res.render(__dirname + '/team', { f: result, s: 0 });
            console.log("result");
        })
    })
});
app.post('/team', function (req, res) {

    console.log(req.body);
    var id = tempstorage.getItem('userid');
    var name = req.body.N2;
    var team = req.body.team;
    var flag = 0;

    db.connect((error) => {

        if (team === 'NULL') {
            db.query('CALL insertteam(?,?,@flag)', [name, id], (error, result) => {
                if (error) {
                    console.log(error);
                }
            });
            db.query('Select @flag as f', (er, r3) => {
                flag = r3[0].f;
                if (flag == 1) {
                    db.query('Select AssociatedTeam from player where ID=?' ,[tempstorage.getItem('userid')] , (er, rs) => {
                        tempstorage.setItem('teamid', rs[0].AssociatedTeam);
                        console.log(rs[0].AssociatedTeam);
                    })
                    console.log(tempstorage.getItem('teamid'));
                    res.redirect('/calender.html')
                }
                else {
                    var sp = tempstorage.getItem('psports')
                    db.query("SELECT name FROM Team where sportstype=? ",[sp], (error, result) => {
                        console.log(result);
                        res.render(__dirname + '/team', { f: result, s: 0 });
                        console.log("result");
                    })
                }
                console.log(1);

            })


        }
        else {
            db.query('CALL addteam(?,?,@flag)', [team, id], (error, result) => {

            });
            db.query('Select @flag as f', (er, r3) => {
                flag = r3[0].f;
                console.log(flag);
                if (flag == 1) {
                    db.query('Select AssociatedTeam from player where ID=?', [tempstorage.getItem('userid')], (er, rs) => {
                        tempstorage.setItem('teamid', rs[0].AssociatedTeam);
                    })
                    console.log(tempstorage.getItem('teamid'));
                    res.redirect('/calender.html')
                }
                else {
                    var sp = tempstorage.getItem('psports')
                    db.query("SELECT name FROM Team where sportstype=? ",[sp], (error, result) => {
                        console.log(result);
                        res.render(__dirname + '/team', { f: result, s: flag });
                        console.log("result");
                    })
                }
                console.log(2);

            })






        }
    });;
    //res.redirect('/lg');
});

//Account 
app.get('/account', (req, res) => {

    var playerId = tempstorage.getItem("userid");
    console.log('-----------', tempstorage.getItem("userid"))
    const QuerySearchPlayer = 'SELECT Player.ID, Player.name AS pname, Sports.name AS sport_name, Team.name AS team_name,Team.rating as Rating, Player.contactnumber, Player.email FROM Player LEFT JOIN Sports ON Player.sportstype = Sports.ID LEFT JOIN Team ON Player.AssociatedTeam = Team.ID WHERE Player.id = ?';
    const QueryGetPastMatchesHistory = 'SELECT m.ID AS MatchID, mt.name AS MatchTypeName, m.TimeOfMatch, m.DateofMatch, f.name AS FieldName FROM Matches m LEFT JOIN MatchType mt ON m.matchtype = mt.ID  LEFT JOIN Field f ON m.field = f.ID WHERE m.Team1 IN (SELECT AssociatedTeam FROM Player WHERE ID = ?) OR m.Team2 IN (SELECT AssociatedTeam FROM Player WHERE ID = ?)';

    // Use an array to store the results of both queries
    let resultsArrayPlayer = [];

    // query to fetch current users details
    db.query(QuerySearchPlayer, [playerId], (error, resultPlayer) => {
        if (error) {
            console.error('Error fetching player details:', error);
            return res.status(500).send('Error fetching player details.');
        }

        resultsArrayPlayer.push(resultPlayer);

        // Execute the second query to fetch current users past matches
        db.query(QueryGetPastMatchesHistory, [playerId, playerId], (error, resultPlayerHistory) => {
            if (error) {
                console.error('Error fetching player past matches details:', error);
                return res.status(500).send('Error fetching player past matches details.');
            }

            resultsArrayPlayer.push(resultPlayerHistory);

            // Combine the results and render the page
            const players = [...resultsArrayPlayer[0], ...resultsArrayPlayer[1]];
            res.render(__dirname + '/account', { r1: players });
        });
    });

});

//Feed Page
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

    db.query('CALL rewards(?,@Flag)', [tempstorage.getItem('userid')], function (err, result) {
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

//Tournament Registration Page handled
app.get('/TournamentReg', (req, res) => {
    console.log("yo");
    db.connect((error) => {
        if (error) console.log(error);

        db.query("SELECT name FROM Field", (error, result) => {
            res.render(__dirname + '/TournamentReg', { f: result, s: 1 });
        })
    })
});
app.post('/TournamentReg', (req, res) => {
    console.log("yo");
    var name = req.body.N1;
    var Date = req.body.D1;
    var Duration = req.body.T1;
    var sports = req.body.sportsid;
    var noofteams = req.body.M1;
    var entry = req.body.E1;
    var location = req.body.Fieldname;
    console.log(sports);
    console.log(location);
    db.connect((error) => {
        db.query('CALL inserttournament(?,?,?,?,?,?,?,?,?,@p_flag)', [name, location, noofteams, Duration, Date, sports, entry, tempstorage.getItem("userid"), tempstorage.getItem("teamid")], (error, result) => {

            if (error) {
                console.log("");
            }
            db.query('Select @p_flag as flag', (er2, r2) => {
                console.log(r2);
                if (r2[0].flag != 1) {
                    db.query("SELECT name FROM Field", (error, re3) => {
                        res.render(__dirname + '/TournamentReg', { f: re3, s: r2[0].flag });
                    })
                }
                else {
                    var amount;
                    db.query("SELECT entry_fee FROM tournament WHERE name=\"" + name + "\"", (er3, r6) => {
                        console.log(r6);
                        amount = r6[0].entry_fee;
                    })
                    tempstorage.setItem('pflag', 1);
                    db.query('Select ID from field where name=?',[location],(e,r)=>{
                        tempstorage.setItem('field',r[0].ID);
                        res.redirect('/Payment');
                    })
                }
            })

        });
    })

    // db.query('INSERT INTO Test VALUES('+req.body.N1+')');
})

//Sign up page handled
app.get('/sign', (req, res) => {
    //var flag=0;+
    res.render(__dirname + "/sign", { s: 0 });

});
app.post('/sign', function (req, res) {

    var sp;


    switch (req.body.sport) {
        case 'Cricket':
            sp = 2;
            tempstorage.setItem("psports", 2);
            break;
        case 'Football':
            sp = 1;
            tempstorage.setItem("psports", 1);
            break;
        case 'Basketball':
            sp = 4;
            tempstorage.setItem("psports", 4);
            break;
        case 'Tennis':
            sp = 3;
            tempstorage.setItem("psports", 3);
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
                    {
                        console.log('Signup successful');
                        db.query('Select ID from player where username=\"' + uname + "\"", (er, rs) => {
                            tempstorage.setItem("userid", rs[0].ID);
                        })
                        res.redirect('/team');
                        break;
                    }
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
})

//Login Page Handled
app.get('/lg', (req, res) => {
    res.render(__dirname + '/lg', { l: -1 });

});
app.post('/lg', function (req, res) {



    db.query('CALL UserLogin(?,?,@Flag)', [req.body.user, req.body.pass], function (err, result) {
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

            //res.render(__dirname+'/lg',{l:flag});
            switch (flag) {

                case 0:
                    console.log("Successfull signin");
                    res.redirect('/calender.html');
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
    db.query('Select ID from player where username=\"' + req.body.user + "\"", (er, rs) => {
        tempstorage.setItem("userid", rs[0].ID);
    })
    db.query('Select AssociatedTeam from player where username=\"' + req.body.user + "\"", (er, rs) => {
        tempstorage.setItem("teamid", rs[0].AssociatedTeam);
    })
    db.query('Select sportstype  from player where username=\"' + req.body.user + "\"", (er, rs) => {
        tempstorage.setItem("psports", rs[0].sportstype);
    })

});

//Bookings of Regular Match
app.get('/setMatches1', (req, res) => {
    db.connect((error) => {
        if (error) console.log(error);
        db.query("SELECT name FROM Field where sportsoffering=? ", [tempstorage.getItem('psports')], (error, result) => {
            res.render(__dirname + '/setMatches1', { f: result, s: -1 });
        })
    })
})
app.post('/setMatches1', function (req, res) {
    var date = req.body.D1;
    var time = req.body.M1;
    var field = req.body.Fieldname;
    db.connect((error) => {
        db.query('CALL findmatch(?,?,?,?,?,@Flag)', [field, time + ':00', tempstorage.getItem("userid"), tempstorage.getItem("teamid"), date], function (err, result) {
            if (err) {
                console.error('Error calling stored procedure : ', err);
            }
            db.query('SELECT @Flag as flag', (err, row) => {
                console.log(row[0].flag);
                if (row[0].flag != 1) {
                    db.query("SELECT name FROM Field where sportsoffering=?", [tempstorage.getItem('psports')], (error, re) => {
                        res.render(__dirname + '/setMatches1', { f: re, s: row[0].flag });
                    })
                }
                else {
                    db.query('CALL insertMatch(?,?,?,?)', [req.body.M1, req.body.D1, tempstorage.getItem('teamid'), req.body.Fieldname], (err, r33) => {
                        if (err) console.log(err);
                    })
                    tempstorage.setItem('pflag', 1);
                    db.query('SELECT ID from field where name=?',[field],(er,r)=>{
                        tempstorage.setItem('field', r[0].ID);
                        tempstorage.setItem('pflag', 1);
                        res.redirect('/Payment');
                    })
                    
                }


            })

        })
    }
    )
})

//Tournament Information Showed and From here team can register into Tournament
app.get('/Tournamentinfo', (req, res) => {
    var tournamentsearchname = tempstorage.getItem("TorinfoId");
    JSON.stringify(tournamentsearchname);
    console.log(tournamentsearchname);
    db.connect((error) => {
        db.query("SELECT * FROM tournament WHERE name=\"" + tournamentsearchname + "\"", (er1, r1) => {
            db.query("SELECT name FROM field where ID=" + r1[0].field, (er2, r2) => {
                db.query("SELECT name FROM sports where ID=" + r1[0].sports, (er3, r3) => {
                    res.render(__dirname + '/Tournamentinfo', { info: r1, fn: r2, s1: r3, s: 1 });
                })
            })
        })
    })
})
app.post('/Tournamentinfo', (req, res) => {
    tournamentsearchname = tempstorage.getItem("TorinfoId");
    db.connect((error) => {
        db.query('CALL Checktournament(?,?,?,@flag)', [tournamentsearchname, tempstorage.getItem("userid"), tempstorage.getItem("teamid")], (er1, r1) => {
            db.query('SELECT @flag as flag', (er2, r2) => {
                console.log(r2[0].flag);
                if (r2[0].flag != 1) {
                    console.log(r2[0].flag);
                    db.query("SELECT * FROM tournament WHERE name=\"" + tournamentsearchname + "\"", (er3, r3) => {
                        db.query("SELECT name FROM field where ID=" + r3[0].field, (er4, r4) => {
                            db.query("SELECT name FROM sports where ID=" + r3[0].sports, (er5, r5) => {
                                res.render(__dirname + '/Tournamentinfo', { info: r3, fn: r4, s1: r5, s: r2[0].flag });
                            })
                        })
                    })
                }
                else {
                    db.query('SELECT ID,entry_fee,field from tournament where name= ?', [tempstorage.getItem("TorinfoId")], (er, r) => {
                        db.query('INSERT INTO torregistration(torid,teamid) values(?,?)', [r[0].ID, tempstorage.getItem('teamid')], (er1, r4) => {
                            if (er1) console.log(er1);
                        });
                        tempstorage.setItem('field',r[0].field);
                        tempstorage.setItem('amount',r[0].entry_fee);
                        tempstorage.setItem('pflag',2);
                        res.redirect('/Payment');
                    })

                }
            })
        })
    })
})

// Match details page which is a tab in calender page
app.get('/Match', (req, res) => {
    db.connect(function (error) {
        if (error) throw error;
        console.log("connect");

        db.query("SELECT m.ID,m.DateofMatch as Date,mt.name as Type,t1.name AS TEAM1,t2.name as TEAM2,t1.sportstype as Sports FROM Matches m  JOIN Matchtype mt on  m.matchtype=mt.ID JOIN Team t1 on t1.ID=Team1  JOIN Team t2 on t2.ID=Team2  WHERE DateofMatch>=CURDATE() ORDER BY DateofMatch ASC ", function (error, result) {
            if (error) throw error;
            res.render(__dirname + '/Match', { data: result });
        });
    })



})

// Tournament details page which is a tab in calender page
app.get('/Tour', (req, res) => {
    db.connect(function (error) {
        if (error) throw error;
        console.log("connect");

        db.query("SELECT name,startingDate,noofmatches FROM Tournament WHERE startingDate>=CURDATE() and PlayerID !=? and sports=? ",[tempstorage.getItem('userid'),tempstorage.getItem('psports')], function (error, result) {
            if (error) throw error;
            res.render(__dirname + '/Tour', { data1: result });
        });
    })
})
app.post('/Tour', (req, res) => {
    //tempstorage.setItem("TorinfoId",req.body.Tournament);
    console.log(req.body.Tournament);
    tempstorage.setItem('TorinfoId', req.body.Tournament);
    res.redirect('/Tournamentinfo');
})

// History page which is a tab in calender page
app.get('/history', (req, res) => {
    db.connect(function (error) {
        if (error) throw error;
        console.log("connect");

        db.query("SELECT m.ID,m.DateofMatch as Date,mt.name as Type,t1.name AS TEAM1,t2.name as TEAM2 FROM Matches m   JOIN Matchtype mt on  m.matchtype=mt.ID JOIN Team t1 on t1.ID=Team1   JOIN Team t2 on t2.ID=Team2  WHERE DateofMatch<CURDATE()  ORDER BY DateofMatch ASC", function (error, result) {
            if (error) throw error;

            db.query("SELECT name,startingDate,noofmatches FROM Tournament WHERE startingDate<CURDATE()", function (err, result1) {
                if (err) throw err;
                // Combine both query results into a single object
                const data = {
                    data2: result,
                    data3: result1
                }
                console.log(result);
                console.log(result1);

                res.render(__dirname + '/history', data);
            })

        });

    })
})
// Pending Match details page which is a tab in calender page
app.get('/pending', (req, res) => {
    db.connect(function (error) {
        if (error) throw error;
        console.log("connect");

        db.query("SELECT m.ID, m.DateofMatch AS Date, mt.name AS Type, t1.name AS TEAM1, m.Team2 AS TEAM2 FROM Matches m JOIN Matchtype mt ON m.matchtype = mt.ID JOIN Team t1 ON t1.ID = m.Team1 WHERE m.Team2 IS NULL AND t1.ID <> " + tempstorage.getItem("userid") + " AND t1.sportstype = " + tempstorage.getItem("psports") + " ORDER BY DateofMatch ASC", function (error, result) {
            if (error) throw error;
            res.render(__dirname + '/pending', { d: result });
        });
    })

})

app.post('/pending', (req, res) => {
    console.log(tempstorage.getItem('teamid'));
    console.log("ok1");
    var sql = "UPDATE Matches SET Team2 = " + tempstorage.getItem('teamid') + " WHERE ID = " + db.escape(req.body.Pend1);
    console.log(sql);
    db.query(sql, function (error, result) {
        if (error) throw error;
        db.query('SELECT field from matches where ID=?',[req.body.Pend1],(er2,r2)=>{
            tempstorage.setItem('field', r2[0].field);
            tempstorage.setItem('pflag', 1);
            res.redirect('/Payment');
        })
    });
})

//Payment page
app.get('/Payment', (req, res) => {
    var amount;
    var flag = tempstorage.getItem('pflag');

    console.log(flag);
    if (flag == 1) {
        tempstorage.setItem('amount',50);
    }
    else {
        amount = tempstorage.getItem('amount');

    }
    console.log(amount);
    res.render(__dirname + '/payment', { s: amount });
    console.log(flag);
});
app.post('/Payment', (req, res) => {

    var flag = tempstorage.getItem('pflag');

    console.log(flag);
    var field
    field = tempstorage.getItem('field');
    tempstorage.removeItem('field');
    tempstorage.removeItem('pflag');
    var date = req.body.D1; 
    console.log(req.body.selectedPaymentMethod);
    db.connect((error) => {

        db.query('call pamin(?,?,?,?,?,?)', [date, tempstorage.getItem('amount'), 'sadapay', req.body.selectedPaymentMethod,tempstorage.getItem('userid') , field], (error, result) => {
            if (error) {
                console.log(error);
            }
            res.redirect('/calender.html');

        });
    })

    // db.query('INSERT INTO Test VALUES('+req.body.N1+')');
})
//Ramisha part
// Render the initial search page
app.get('/Search', (req, res) => {
    res.render(__dirname + '/Search', { players: [] }); // Render the search page with an empty list of players
});

// Handle form submission for search  and sending available players to dropdown
app.post('/Search', (req, res) => {
    const playerToSearchName = req.body.SearchPlayer;
    const searchTerm = '%' + playerToSearchName + '%';

    const GetPlayersByNameLikeSimpleQuery = 'SELECT id, name, "player" AS type FROM Player WHERE Player.name LIKE ?';
    const GetTeamsByNameLikeSimpleQuery = 'SELECT id, name, "team" AS type FROM Team WHERE Team.name LIKE ?';

    // Wrap database queries in promises
    const getPlayersPromise = new Promise((resolve, reject) => {
        db.query(GetPlayersByNameLikeSimpleQuery, [searchTerm], (error, playerss) => {
            if (error) {
                reject(error);
            } else {
                resolve(playerss);
            }
        });
    });

    const getTeamsPromise = new Promise((resolve, reject) => {
        db.query(GetTeamsByNameLikeSimpleQuery, [searchTerm], (error, teams) => {
            if (error) {
                reject(error);
            } else {
                resolve(teams);
            }
        });
    });

    // Wait for both promises to resolve
    Promise.all([getPlayersPromise, getTeamsPromise])
        .then(([playerss, teams]) => {
            const playersWithType = playerss.map(player => ({ ...player, type: 'player' }));
            const teamsWithType = teams.map(team => ({ ...team, type: 'team' }));
            const players = [...playerss, ...teams];
            const searchResults = [...playersWithType, ...teamsWithType];
            // Render the Search page with the search results
            res.render(__dirname + '/Search', { players: searchResults });
        })
        .catch(error => {
            console.error(error);
            res.status(500).send('Error searching for players.');
        });
});

// Define a route for the player profile page(fetches a player and redirects to playerProfile page)
app.get('/playerProfile/:playerId', (req, res) => {


    var playerId = req.params.playerId;
    const QuerySearchPlayer = 'SELECT Player.ID, Player.name AS pname, Sports.name AS sport_name, Team.name AS team_name,Team.rating as Rating, Player.contactnumber, Player.email FROM Player LEFT JOIN Sports ON Player.sportstype = Sports.ID LEFT JOIN Team ON Player.AssociatedTeam = Team.ID WHERE Player.id = ?';
    const QueryGetPastMatchesHistory = 'SELECT m.ID AS MatchID, mt.name AS MatchTypeName, m.TimeOfMatch, m.DateofMatch, f.name AS FieldName FROM Matches m LEFT JOIN MatchType mt ON m.matchtype = mt.ID LEFT JOIN Field f ON m.field = f.ID WHERE (m.Team1 IN (SELECT AssociatedTeam FROM Player WHERE ID = ?) OR m.Team2 IN (SELECT AssociatedTeam FROM Player WHERE ID = ?)) AND TIMESTAMP(m.DateofMatch, m.TimeOfMatch)<NOW();';

    // Use an array to store the results of both queries
    let resultsArrayPlayer = [];

    // Execute the first query to fetch player details
    db.query(QuerySearchPlayer, [playerId], (error, resultPlayer) => {
        if (error) {
            console.error('Error fetching player details:', error);
            return res.status(500).send('Error fetching player details.');
        }
        // Push the result into the array
        resultsArrayPlayer.push(resultPlayer);

        // Execute the second query to fetch player's past matches
        db.query(QueryGetPastMatchesHistory, [playerId, playerId], (error, resultPlayerHistory) => {
            if (error) {
                console.error('Error fetching player past matches details:', error);
                return res.status(500).send('Error fetching player past matches details.');
            }
            // Push the result into the array
            resultsArrayPlayer.push(resultPlayerHistory);

            // Combine the results and render the page
            const players = [...resultsArrayPlayer[0], ...resultsArrayPlayer[1]];
            console.log('player full details fetched in function: ', players);
            res.render(__dirname + '/playerProfile', { r1: players });
        });
    });

});
//defines a route for teaminfo page(fetches its details and redirects to teamInfo)
app.get('/teamInfo/:playerId', (req, res) => {

    var TeamId = req.params.playerId;

    // Define the queries to fetch team details and team matches
    const QuerySearchTeam = 'SELECT Team.name AS TeamName, Player.name AS CaptainName, Sports.name AS SportsName, Team.rating AS TeamRating FROM Team LEFT JOIN captains ON Team.ID = captains.teamid LEFT JOIN Player ON captains.playerid = Player.ID JOIN Sports ON Team.sportstype = Sports.ID WHERE Team.ID = ?';
    const QueryGetTeamMatches = 'SELECT Matches.ID AS MatchID,  MatchType.name AS MatchTypeName, Matches.TimeOfMatch, Matches.DateofMatch, Field.name AS FieldName FROM Team LEFT JOIN Matches ON (Matches.Team1 = Team.ID OR Matches.Team2 = Team.ID) LEFT JOIN MatchType ON Matches.matchtype = MatchType.ID LEFT JOIN Field ON Matches.field = Field.ID WHERE Team.ID = ? AND TIMESTAMP(Matches.DateofMatch, Matches.TimeOfMatch)<NOW()';

    // Use an array to store the results of both queries
    let resultsArrayTeam = [];

    // Execute the query to fetch team details
    db.query(QuerySearchTeam, [TeamId], (error, resultTeam) => {
        if (error) {
            console.error('Error fetching team details:', error);
            return res.status(500).send('Error fetching team details.');
        }
        // Push the result into the array
        resultsArrayTeam.push(resultTeam);

        // Execute the query to fetch team matches
        db.query(QueryGetTeamMatches, [TeamId], (error, resultTeamMatches) => {
            if (error) {
                console.error('Error fetching team matches details:', error);
                return res.status(500).send('Error fetching team matches details.');
            }
            // Push the result into the array
            resultsArrayTeam.push(resultTeamMatches);

            const TeamDetails = [...resultsArrayTeam[0], ...resultsArrayTeam[1]];
            console.log('Team full details fetched in function: ', TeamDetails);
            res.render(__dirname + '/teamInfo', { r2: TeamDetails });
        });
    });
});
//rating to a team
app.post('/teamInfo/:playerId', (req, res) => {
    const addRating = req.body.addRating;
    console.log('rating sent by the frontend:', addRating);
    // Update the rating in the database
    const teamID = req.params.playerId;
   

    // Assuming you have a database connection object called 'db'
    db.query(
        'UPDATE Team SET countRatings = countRatings + 1, rating = (rating * (countRatings) + ?) / (countRatings + 1) WHERE Team.ID =?',
        [addRating, teamID],
        (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error updating rating');
        } else {
            res.send('Rating updated!');
           
        }
        }
    );
});
//Field Registeration Page
app.get('/field', (req, res) => {
    res.render(__dirname + '/field', { s: 1 });
})
app.post('/field', (req, res) => {
    db.query("CALL insertField(?,?,?,?,?,?,@flag)", [req.body.fn, req.body.on, req.body.email, req.body.location, req.body.phone, req.body.sport], (er1, r1) => {
        db.query('Select @flag as flag', (er2, r2) => {
            if (r2[0].flag == 0) {
                res.render(__dirname + '/field', { s: 0 })
            }
            else {
                res.redirect('/lg');
            }
        })
    })
})

//Tournament Match setting step 1
app.get('/tor', (req, res) => {
    var id = tempstorage.getItem('userid');
    db.connect((error) => {

        db.query("SELECT name FROM Tournament where PlayerID=? ", [id], (er4, r4) => {
            if (er4) console.log(er4);
            res.render(__dirname + '/tor', { t: r4 });
        })


    })
})
app.post('/tor', (req, res) => {

    var na = req.body.Ty;
    console.log(na);
    db.query("SELECT ID FROM Tournament WHERE name = ?", [na], (er4, r4) => {
        if (er4) {
            console.log(er4);
            // Handle error if needed
        } else {
            if (r4.length > 0) {
                var tid = r4[0].ID;
                console.log(tid);
                tempstorage.setItem('torid', tid);
                res.redirect('/tor2');

            } else {
                console.log("Tournament not found");
                // Handle case where no tournament is found with the given name
            }
        }
    });

})

//Tournament Match setting step 2
app.get('/tor2', (req, res) => {
    var torid = tempstorage.getItem('torid');
    var s = 1;
    console.log(torid); // This will log the value stored in 'torid' to the console ;
    db.connect((error) => {

        db.query(" SELECT name FROM team join torregistration as t  on ID=teamid where torid=? ", [torid], (er4, r4) => {
            if (er4) console.log(er4);
            console.log(r4);
            res.render(__dirname + '/tormat', { t: r4, s: s });
        })


    })
})
app.post('/tor2', (req, res) => {
    var torid = tempstorage.getItem('torid');
    console.log(req.body);
    db.query(" SELECT field FROM tournament where ID=? ", [torid], (er4, r4) => {
        console.log(r4);
        var fi = r4[0].field;
        console.log(fi);
        db.query('CALL insertTourMatch(?,?,?,?,?,?,?,@flag)', [2, req.body.M1, req.body.D1, req.body.T1, req.body.T2, fi,torid], (err, r1) => {
            db.query('SELECT @flag as flag', (er2, r2) => {
                db.query(" SELECT name FROM team join torregistration as t  on ID=teamid where torid=? ", [torid], (er5, r5) => {
                    console.log(r2[0].flag);
                    if (r2[0].flag != 1) {
                        res.render(__dirname + '/tormat', { t: r5, s: r2[0].flag });
                    }
                    else {
                        res.redirect('/calender.html');
                    }
                })

            })
        })
    })
})

app.listen(3000);