var crowdready = artifacts.require("crowdready.sol");
module.exports = function (deployer) {
 deployer.deploy(crowdready, "5");
};