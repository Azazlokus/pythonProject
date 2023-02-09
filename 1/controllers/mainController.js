const createPath = require('../helpers/createPath');

const getMain = (req, res) => {
    return res.render(createPath(index));
};

module.exports = {
    getMain,
}