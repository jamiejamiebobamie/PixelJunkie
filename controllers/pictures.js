const User = require('../models/user');
const Picture = require('../models/picture');
const Pixel = require('../models/pixel');


// TRANSACTIONS GET ROUTE, SHOW TRANSACTIONS PAGE
    app.post('/buy', (req, res) => {
        var currentUser = req.user;

        if (currentUser) {
        User.findOne({_id: req.user})
            .then(user => {
               Stock.findOne( {symbol: ticker, owner: user} )
               .then(stock => {

            });
            });
                res.redirect('/');
            } else {
            res.redirect('/register');
        }
    });
