// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Cal {
    uint256 public value;

    function increment(uint256 _val) external {
        value += _val;
    }

    function decrement(uint256 _val) external {
        require(value >= _val, "Cannot decrement below zero");
        value -= _val;
    }
}

contract MinimalProxyFactory {
    
    address[] public proxies;

    function deployClone(address _implementationContract) external returns (address) {
        // convert the address to 20 bytes
        bytes20 implementationContractInBytes = bytes20(_implementationContract);
        //address to assign a cloned proxy
        address proxy;
        
    
        // as stated earlier, the minimal proxy has this bytecode
        // <3d602d80600a3d3981f3363d3d373d3d3d363d73><address of implementation contract><5af43d82803e903d91602b57fd5bf3>

        // <3d602d80600a3d3981f3> == creation code which copies runtime code into memory and deploys it

        // <363d3d373d3d3d363d73> <address of implementation contract> <5af43d82803e903d91602b57fd5bf3> == runtime code that makes a delegatecall to the implentation contract
 

        assembly {
            /*
            reads the 32 bytes of memory starting at the pointer stored in 0x40
            In solidity, the 0x40 slot in memory is special: it contains the "free memory pointer"
            which points to the end of the currently allocated memory.
            */
            let clone := mload(0x40)
            // store 32 bytes to memory starting at "clone"
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )

            /*
              |              20 bytes                |
            0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
                                                      ^
                                                      pointer
            */
            // store 32 bytes to memory starting at "clone" + 20 bytes
            // 0x14 = 20
            mstore(add(clone, 0x14), implementationContractInBytes)

            /*
              |               20 bytes               |                 20 bytes              |
            0x3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe
                                                                                              ^
                                                                                              pointer
            */
            // store 32 bytes to memory starting at "clone" + 40 bytes
            // 0x28 = 40
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )

            /*
            |                 20 bytes                  |          20 bytes          |           15 bytes          |
            0x3d602d80600a3d3981f3363d3d373d3d3d363d73b<implementationContractInBytes>5af43d82803e903d91602b57fd5bf3 == 45 bytes in total
            */
            
            
            // create a new contract
            // send 0 Ether
            // code starts at the pointer stored in "clone"
            // code size == 0x37 (55 bytes)
            proxy := create(0, clone, 0x37)
        }
        
        // Call initialization
        Cal(proxy).increment(10);
        proxies.push(proxy);
        return proxy;
    }
}



// contract ImplementationContract{
//     bool public isInitialized;      //initializer function that will be called once, during deployment.

//     function initializer() external {              
//         require(!isInitialized,"contract is Initialized");
//         isInitialized =true;     
//     }         
// }


// contract ProxyFactory {
//     event ProxyCreated(address proxy);

//     function createProxy(address _implementation)
//         external
//         returns (address)
//     {
//         bytes20 targetBytes = bytes20(_implementation);
//         address payable proxy;

//         assembly {
//             let clone := mload(0x40)
//             mstore(clone, 0x3d602d80600a3d3981f3)
//             mstore(add(clone, 0x14), targetBytes)
//             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf3)
//             proxy := create(0, clone, 0x37)
//         }

//         require(proxy != address(0), "Proxy deployment failed");

//         emit ProxyCreated(proxy);
//         return proxy;
//     }
// }


