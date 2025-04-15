// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ReputationSystem
 * @dev A reputation system that assigns scores to wallet addresses and mints Soulbound Tokens based on reputation levels
 */
contract ReputationSystem is ERC721, Ownable {
    uint256 private _tokenIds;

    mapping(address => uint256) public reputationScores;
    mapping(address => uint256) public addressToTokenId;

    event ReputationIncreased(address indexed user, uint256 amount, uint256 newScore);
    event ReputationDecreased(address indexed user, uint256 amount, uint256 newScore);
    event ActionCompleted(address indexed user, string actionType);
    event SoulboundTokenMinted(address indexed to, uint256 tokenId, uint256 reputationLevel);

    mapping(string => uint256) public actionPoints;

    struct ReputationLevel {
        string name;
        uint256 threshold;
        string tokenURI;
    }

    ReputationLevel[] public reputationLevels;

    constructor() ERC721("Reputation Soulbound Token", "RST") {
        actionPoints["VOTE_IN_DAO"] = 10;
        actionPoints["COMPLETE_TASK"] = 20;
        actionPoints["VERIFY_ACCOUNT"] = 50;

        reputationLevels.push(ReputationLevel("Novice", 0, "ipfs://QmHash1"));
        reputationLevels.push(ReputationLevel("Contributor", 100, "ipfs://QmHash2"));
        reputationLevels.push(ReputationLevel("Trusted", 300, "ipfs://QmHash3"));
        reputationLevels.push(ReputationLevel("Expert", 700, "ipfs://QmHash4"));
        reputationLevels.push(ReputationLevel("Master", 1500, "ipfs://QmHash5"));
    }

    function completeAction(address user, string memory actionType) external  {
        require(actionPoints[actionType] > 0, "Action type not recognized");

        uint256 pointsToAdd = actionPoints[actionType];
        _increaseReputation(user, pointsToAdd);

        emit ActionCompleted(user, actionType);

        _checkAndMintSBT(user);
    }

    function addActionType(string memory actionType, uint256 points) external  {
        actionPoints[actionType] = points;
    }

    function increaseReputation(address user, uint256 amount) external{
        _increaseReputation(user, amount);
        _checkAndMintSBT(user);
    }

    function decreaseReputation(address user, uint256 amount) external  {
        require(reputationScores[user] >= amount, "Reputation cannot go below zero");

        reputationScores[user] -= amount;
        emit ReputationDecreased(user, amount, reputationScores[user]);
    }

    function getReputationLevel(address user) public view returns (uint256 levelId, string memory levelName) {
        uint256 score = reputationScores[user];

        for (uint256 i = reputationLevels.length - 1; i >= 0; i--) {
            if (score >= reputationLevels[i].threshold) {
                return (i, reputationLevels[i].name);
            }

            if (i == 0) break; // Prevent underflow
        }

        return (0, reputationLevels[0].name);
    }

    function _increaseReputation(address user, uint256 amount) internal {
        reputationScores[user] += amount;
        emit ReputationIncreased(user, amount, reputationScores[user]);
    }

    function _checkAndMintSBT(address user) internal {
        (uint256 newLevelId, ) = getReputationLevel(user);

        if (addressToTokenId[user] == 0) {
            _mintSBT(user, newLevelId);
        }
    }

    function _mintSBT(address to, uint256 levelId) internal {
        _tokenIds++;
        uint256 newTokenId = _tokenIds;

        _mint(to, newTokenId);
        addressToTokenId[to] = newTokenId;

        emit SoulboundTokenMinted(to, newTokenId, levelId);
    }

    // Modified function to address all warnings
    function _transfer(address, address, uint256) internal pure override {
        revert("Soulbound tokens cannot be transferred");
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721: invalid token ID");

        address owner = ownerOf(tokenId);
        (uint256 levelId, ) = getReputationLevel(owner);

        return reputationLevels[levelId].tokenURI;
    }

    function addReputationLevel(string memory name, uint256 threshold, string memory levelTokenURI) external {
        reputationLevels.push(ReputationLevel(name, threshold, levelTokenURI));
    }
}
