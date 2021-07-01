// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract RockPaperScissors {
    uint gamesPlayed;
    
    struct Game {
        address first_player;
        address second_player;
        string first_player_choice;
        string second_player_choice;
    }
    
    // Mapping of IDs to games
    mapping(uint => Game) games;
    
    // To get the total number of games played
    function count() public view returns(uint){
        return gamesPlayed;
    }
    
    // Start a game with desired opponent
    function startGameWith(address opponent) public{
        // You can't play with yourself
        require(msg.sender!=opponent);
        gamesPlayed++;
        Game storage game = games[gamesPlayed];
        game.first_player = msg.sender;
        game.second_player = opponent;
    }
    
    // Choose your move in a particular game
    function makeMove(uint gameId, string memory move) public{
        Game storage game = games[gameId];
        string memory empty = "";
        // Game must exist
        require(gameId<=gamesPlayed);
        // Must be permitted to play the game
        require(msg.sender==game.first_player || msg.sender==game.second_player);
        // Makes only a valid move
        require(compareStrings(move,"ROCK") || compareStrings(move,"PAPER") || compareStrings(move,"SCISSORS"));
        if(msg.sender==game.first_player){
            // Must be making a fresh move
            require(compareStrings(game.first_player_choice, empty));
            game.first_player_choice=move;
        } else {
            // Must be making a fresh move
            require(compareStrings(game.second_player_choice,empty));
            game.second_player_choice=move;
        }
    }
    
    // Get winner for a game
    function getWinner(uint gameId) public view returns(address){
        Game storage game = games[gameId];
        string memory empty = "";
        // Check if both players are done
        require(!compareStrings(game.first_player_choice, empty) && !compareStrings(game.second_player_choice,empty));
        // Check if it's not a tie
        if(compareStrings(game.first_player_choice,game.second_player_choice)){
            return address(0);
        }
        // Shortening the variables 
        
        string memory f = game.first_player_choice;
        string memory s = game.second_player_choice;
        // Check if player one wins, i.e.: (R, S) or (S,P) or (P,R)
        if((compareStrings(f,"ROCK")&&compareStrings(s,"SCISSORS")) || (compareStrings(f,"SCISSORS")&&compareStrings(s,"PAPER")) || (compareStrings(f,"PAPER")&&compareStrings(s,"ROCK"))) {
            return game.first_player;
        }
        return game.second_player;
    }
    
    // compare Strings
    function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}
