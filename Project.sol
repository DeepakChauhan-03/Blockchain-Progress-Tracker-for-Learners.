// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProgressTracker {

    // Structure to store learner details and their progress
    struct Learner {
        string name;
        string email;
        uint256 completedModules;
        uint256 totalModules;
        bool isRegistered;
    }

    // Owner of the contract
    address public owner;

    // Mapping to store learners' progress by their wallet address
    mapping(address => Learner) public learners;

    // Event to log progress updates
    event ProgressUpdated(address indexed learner, uint256 completedModules, uint256 totalModules);

    // Event to log new learner registration
    event LearnerRegistered(address indexed learner, string name, string email);

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to register a learner
    function registerLearner(address _learner, string memory _name, string memory _email, uint256 _totalModules) public onlyOwner {
        require(!learners[_learner].isRegistered, "Learner is already registered");
        learners[_learner] = Learner({
            name: _name,
            email: _email,
            completedModules: 0,
            totalModules: _totalModules,
            isRegistered: true
        });
        emit LearnerRegistered(_learner, _name, _email);
    }

    // Function for learners to update their progress
    function updateProgress(uint256 _completedModules) public {
        require(learners[msg.sender].isRegistered, "Learner is not registered");
        require(_completedModules <= learners[msg.sender].totalModules, "Completed modules cannot exceed total modules");

        learners[msg.sender].completedModules = _completedModules;
        emit ProgressUpdated(msg.sender, _completedModules, learners[msg.sender].totalModules);
    }

    // Function to fetch learner progress
    function getProgress(address _learner) public view returns (string memory, uint256, uint256) {
        require(learners[_learner].isRegistered, "Learner is not registered");
        Learner memory learner = learners[_learner];
        return (learner.name, learner.completedModules, learner.totalModules);
    }
}
