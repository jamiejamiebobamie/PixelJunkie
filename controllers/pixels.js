const User = require('../models/user');
const Picture = require('../models/picture');
const Pixel = require('../models/pixel');

module.exports = (app) => {

    // TRANSACTIONS GET ROUTE, SHOW TRANSACTIONS PAGE
        app.get('/myPixels', (req, res) => {
            var currentUser = req.user;
            let pixels;
            if (currentUser) {
            User.findOne({_id: req.user})
                .then(user => {
                    pixels = user.pixels;
                res.render('myPixels', {currentUser, pixels});
            });
            } else {
                res.render('sign-in', currentUser);
            }
        });
};
