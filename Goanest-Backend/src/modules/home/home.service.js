const exploreService = require('../explore/explore.service');
// The guest Home and Explore screens share one screen-ready contract. The
// /home alias is kept as the canonical mobile endpoint.
const getHome = (userId, tab = 'all') => exploreService.getExplore(userId, tab);

module.exports = { getHome };
