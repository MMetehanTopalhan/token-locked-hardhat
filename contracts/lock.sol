// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import"./token.sol";



contract Lock {
    
    BEEToken Token;
    uint256 public lockerCount; //içerde kaç kullanıcı kitli
    uint256 public totalLocked; // kontort içinde nekadar para olduğunu gösterir
    mapping (address => uint256) public lockers;

      constructor(address tokenAddress) {
        Token = BEEToken(tokenAddress);
    }

function lockTokens(uint256 amount) external{ //kitleme
require(amount > 0, "Token amount must be bigger than 0. ");

//require(Token.balanceOf(msg.sender) >= amount,"İnsufficient balance." ); //kullanıcın parası var mı
//require(Token.allowance(msg.sender, address(this)  >= amount,"İnsufficient balance." ); //contrata harcama yetkisi vermiş mi?
//gerek yok çünkü erc baba kontrol ediyor

if(!(lockers[msg.sender] > 0))lockerCount++; //daha  önce bir kitleme yapmışsa sıfırdan buyüktür eğer değilse parasız veya ilk kitleme
totalLocked+= amount;
lockers[msg.sender] += amount;


bool ok = Token.transferFrom(msg.sender, address(this), amount ); //para getirici bool döndürme , transfer yapıldı mı yapılmadı mı  takibi
require(ok, "transfer failed");
}

function withdrawTokens() external {
require(lockers[msg.sender] > 0,"not enough token." );//parası var mı diye bakıyoruz

uint256 amount = lockers[msg.sender];
delete(lockers[msg.sender]);
totalLocked -= amount;
lockerCount--;

require(Token.transfer(msg.sender, amount), "Transfer failed.");

}

}