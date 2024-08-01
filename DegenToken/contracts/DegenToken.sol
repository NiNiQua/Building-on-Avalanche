// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts@4.9/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("Degen", "DGN") {
        _mint(msg.sender, initialSupply);
        addItem("Sweatshirt", 15);
        addItem("Tshirt", 10);
        addItem("Pants", 20);
        addItem("Baseball Cap", 5);
    }

    Item[] public items;

    function mint(uint256 amount) public onlyOwner {
        require(amount > 0, "Mint amount must be greater than 0");
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) public {
        require(amount > 0, "Amount should be greater than 0");
        require(amount <= balanceOf(msg.sender), "Insufficient balance to burn");
        _burn(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(amount > 0, "Transfer amount must be greater than 0");
        _transfer(_msgSender(), to, amount);
        return true;
    }

    struct Item {
        string name;
        uint256 price;
    }

    function buyItem(uint256 itemIndex) public {
        require(itemIndex < items.length, "Item index out of bounds");
        Item storage item = items[itemIndex];
        require(balanceOf(msg.sender) >= item.price, "Insufficient balance to buy item");
        _burn(msg.sender, item.price);
        emit ItemPurchased(msg.sender, item.name, item.price);
    }

    function addItem(string memory name, uint256 price) public onlyOwner {
        require(price > 0, "Item price must be greater than 0");
        items.push(Item(name, price));
    }

    function getItem(uint256 index) public view returns (string memory name, uint256 price) {
        require(index < items.length, "Item index out of bounds");
        Item storage item = items[index];
        return (item.name, item.price);
    }

    event ItemPurchased(address indexed buyer, string itemName, uint256 itemPrice);
}