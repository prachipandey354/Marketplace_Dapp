pragma solidity ^0.5.0;
contract Marketplace{
  string public name;
  uint public productCount=0;
  mapping(uint =>Product)public products;
  struct Product{
    uint id;/*key*/
    string name;
    uint price;
    address payable owner;
    bool purchased;
  }
  event ProductCreated(
    uint id,
    string name,
    uint price,
    address payable owner,
    bool purchased
  );
  event ProductPurchased(
    uint id,
    string name,
    uint price,
    address payable owner,
    bool purchased
  );
  constructor() public{
    name="Prachi Pandey Marketplace";
  }
  function createProduct(string memory _name,uint _price )public{
    //require _name
    require(bytes(_name).length>0);
    //require a valid _price
    require(_price>0);
    //make sure parameters are correct

    //increament product productCount
    productCount++;
    //create the products
    products[productCount]=Product(productCount,_name,_price,msg.sender,false);
    //trigger an event
    emit ProductCreated(productCount,_name,_price,msg.sender,false);
  }
  function purchaseProduct(uint _id)public payable{
    //fetch products
    Product memory _product=products[_id];
    //fetch the owner
    address payable _seller=_product.owner;
    //make sure the product has valid id
    require(_product.id>0&&_product.id<=productCount);
    //requie ther is enough etehr in the transaction
    require(msg.value>=_product.price);
    //require that the product has not been purchased already
    require(!_product.purchased);
    //require that the buyer is not the seller
    require(_seller!=msg.sender);
    //purchase it
    //transfer ownership to buyer
    _product.owner=msg.sender;
    //mark as purchased
    _product.purchased=true;
    //update the product
    products[_id]=_product;
    //pay the _seller by sending them Ether
    address(_seller).transfer(msg.value);
    //trigger an event
    emit ProductPurchased(productCount,_product.name,_product.price,msg.sender,true);
  }
}
