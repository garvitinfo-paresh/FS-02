// JS - loosely typed / not strict
// REPL -A REPL (Read–Eval–Print Loop) is a simple, interactive programming environment that takes a single user command, evaluates it, prints the result, and loops back to wait for the next input

// console.log("1.Hello")
// console.log("2.Hello")
// console.log("3.Hello")
// console.log("4.Hello")
// console.log("5.Hello")


// console.log(1+3)
// console.log(0.1 + 0.3)
// console.log(10%3)

// console.log(typeof(1))

// console.log(typeof(true))
// console.log(true)
// console.log(true+0.5)

// console.log(typeof(10))
// console.log(typeof('10'))
// console.log('10' + 10)

// console.log('10' - 10)
// console.log('10' * 10)
// console.log('10' / 10)

// console.log('10' + '10')
// console.log('10' * '10')
// console.log('10' / '10')

// console.log(typeof('10'))  //true - false 
// console.log(typeof('true'))  //true - false 
// console.log('true'+10)  //true - false 
// console.log('true'-10)
// console.log('true'*10)
// console.log('true'/10) //NaN - Not a Number

// console.log(typeof(NaN))

// console.log('2500'/'10') //NaN - Not a Number
// console.log('2500'/'ten') //NaN - Not a Number

// ----
// 21-11-2026
// ----

// variable  - is an identifier that can store information
// -- variable is identifier
//  identifier is not variable 

// int a;
// int a = 10 ;

// variable can be declare in js using 'var' , 'let', 'const'

// var x;
// var y =10;
// var z =20;


// console.log(y+z);
// x=y+z;
// console.log(x);
// console.log(typeof(x));

// console.log(y+z);

// String in JS 

// using  singlequote '' 
// using  doublequote ""
// using  backtick `` -> use in paragraph - Template literal 


// var str1 = "hello, we `are learning` JS,                  'JS is an amzing language' for development."
// var str2 = `hello, we are "learning" JS, 
// 'JS is an amzing language' 
// for development.`
// console.log(str1)
// console.log(str2)

// console.log("x = ${y+z}")
// console.log('x = ${y+z}')
// console.log(`x = ${y+z}`)

// var x;
// console.log(x) //undefined
 
// ----------- Data Type -----------

// console.log(typeof "Hello")          // String
// console.log(typeof 100)              //number
// console.log(typeof 100.50)           //number
// console.log(typeof true)             //number
// console.log(typeof undefined)        //number
// console.log(typeof null)             //object
// console.log(typeof [])               //object
// console.log(typeof (()=>{}))         //function
// console.log(typeof {})               //object
// console.log(typeof NaN)              //Number
// console.log(typeof 100373289478957437528534752938724)                  //number
// console.log(typeof 100373289478957437528534752938724n)                  //bigint


// 'var' , 'let', 'const

// var x=10;
// {
//     var x=20;
//     console.log(x)
// }
// console.log(x)
// 
// let x=10;
// {
//     let x=20;
//     console.log(x)
// }
// console.log(x)

// --------------

// var x=10;
// var x=20;

// console.log(x);

// let x=10;
// let x=20;

// console.log(x);

// --------------

// console.log(x)
// var  x;
// x=10

// console.log(x)
// let  x; 
// x=10 // Cannot access 'x' before initialization

// ------------------

// let - const

// const X_CONST = 100;
// X_CONST = 101; //Assignment to constant variable.
// console.log(X_CONST)

// ------------------------
// null, NaN, undefined 

// let x = 10;
// let y = '10';
// console.log(x==y)
// console.log(x===y)

// console.log(typeof undefined) // 
// console.log(typeof null)      // empty 
// console.log(typeof NaN)       // 

// console.log(undefined ==undefined) //t
// console.log(undefined ===undefined) //t

// console.log(undefined == null)  //t
// console.log(undefined === null) //f

// console.log(undefined ==  NaN)   //f
// console.log(undefined === NaN)   //f 

// console.log(null == null)   //t
// console.log(null === null)  //t

// console.log(null == NaN)  //f
// console.log(null === NaN) //f

// console.log(NaN == NaN)     //f
// console.log(NaN  === NaN)   //f


// ----------
// 23-11-2026
// ----------

// Array - The Array object, as with arrays in other programming languages, enables storing a collection of multiple items under a single variable name.

// [] 
// index start from 0


// let arr  = [];

// console.log(typeof arr);
// console.log(arr);

// let arr1  = [1,2,'three',4.0,5.0,'six','SEVEN',8,9,'TEN'];
// console.log(arr1);
// console.log(arr1[0]);
// console.log(arr1[3]);
// console.log(typeof arr1[3]);
// console.log(typeof arr1[5]);

// console.log(arr1.length); //length - property

// let arr1  = [10,20,30,40,50,60,70];

// console.log(arr1)
// console.log(arr1.length)

// console.log(arr1[9])
// arr1[9] = 100 
// arr1[90] = 1000 

// arr1[7] = undefined;
// console.log(arr1)
// console.log(arr1[7]==arr1[8])
// console.log(arr1[7]===arr1[8])
// console.log(arr1.length)

// arr1['10'] = 100
// arr1['a'] = 121
// arr1['b'] = 131
// console.log(arr1['b'])
// console.log(arr1)
// console.log(arr1.length)

// 
// let arr1 = [];

// for(let i=0;i<10;i++)
// {
//     arr1[i] = i*10+10
// }

// console.log(arr1[9])
// console.log(arr1[-3])

// -------------------------------------
//           array function
// -------------------------------------

// insert ->    push()  insert - Rear     unshift() insert - Front

// delete ->    pop()       shift()


// let arr1  = [30,40,50,60,70];

// push()
// push(element1)
// push(element1, element2)
// push(element1, element2, /* …, */ elementN)

// console.log(arr1)
// arr1.push() //no change
// arr1.push(80)
// arr1.push(90)
// arr1.push(80,90)
// arr1.push(80,90,100)

// arr1.unshift(20)
// arr1.unshift(10)
// arr1.unshift(10,20)
// console.log(arr1)

// console.log(arr1)
// arr1.pop()
// arr1.pop()
// arr1.shift()
// arr1.shift()
// console.log(arr1)

// -------
// delete - property
// -------


// let arr1  = [30,40,50,60,70];
// console.log(arr1)
// console.log(arr1.length)

// delete arr1[0]
// delete arr1[1]

// console.log(arr1)
// console.log(arr1.length)

//delete never realese memory of deleted element


// ------------------
// IMP - 24-11-2026 
// ------------------

// let arr1 = [100]

// console.log(typeof([]));
// console.log(typeof(" "));

// console.log(arr1);

// console.log(false == " ")
// console.log([] == " ") //object empty - null
// console.log(0 == " ") 
// console.log([] == 0 ) 
// console.log([] == false )


// console.log( 0 == "0" ) 
// console.log([] == 0 )

// console.log([] == "0" )


// ---------------------

// let arr1 = [0];

// console.log(arr1[0] == " ")
// console.log(0 == " ") 

// console.log(arr1[0] === " ")
// console.log(arr1[0] === " ")


// ----------------------------------------
// splice
// ----------------------------------------
// The splice() method of Array instances changes the contents of an array by removing or replacing existing elements and/or adding new elements in place.


// splice(start)
// splice(start, deleteCount)
// splice(start, deleteCount, item1)
// splice(start, deleteCount, item1, item2)
// splice(start, deleteCount, item1, item2, /* …, */ itemN)

// -->
//  0   1   2   3   4   5   6   7   8   9
//  10  20  30  40  50  60  70  80  90  100
//  -10 -9  -8  -7  -6  -5  -4  -3  -2  -1

// let arr1 = [10,  20,  30,  40,  50,  60,  70,  80,  90,  100];

// console.log(arr1);
// arr1.splice(5)
// arr1.splice(8)
// arr1.splice(2)
// arr1.splice(-3)
// arr1.splice(-8)

// arr1.splice(3,2)
// arr1.splice(5,3)
// arr1.splice(-4,3)
// arr1.splice(-9,8)
// arr1.splice(-9,-1)

// arr1.splice(2,3,101)
// let arr2 = arr1.splice(2,3,101,201,301,401)

// console.log(arr1);
// console.log(arr2);
// ---------------------


// ----------------------------------------
// slice
// ----------------------------------------

// The slice() method of Array instances returns a shallow copy of a portion of an array into a new array object selected from start to end (end not included) where start and end represent the index of items in that array. The original array will not be modified.


// slice()
// slice(start)
// slice(start, end)


// let arr = [10,  20,  30,  40,  50,  60,  70,  80,  90,  100];

//Deep Copy
// // let arr1 = arr;  ///aliasing --
// // let arr2 = arr;

//Shallow Copy
// let arr1 = [...arr];
// let arr2 = [...arr];

// let arr1 = arr.slice() 
// let arr2 = arr.slice() 

// console.log(`--------Befor-----------`)
// console.log(`OGArray : ${arr}`)
// console.log(`Array 1 : ${arr1}`)
// console.log(`Array 2 : ${arr2}`)


// arr1.pop();
// arr1.pop();
// arr2.push(1000);
// arr2.push(2000);
// arr2.push(3000);

// console.log(`--------After-----------`)
// console.log(`OGArray : ${arr}`)
// console.log(`Array 1 : ${arr1}`)
// console.log(`Array 2 : ${arr2}`)



// let arr = [10,  20,  30,  40,  50,  60,  70,  80,  90,  100];

// let arr1 = [];
// console.log(`OGArray : ${arr}`)
// arr1  = arr.slice(2)
// arr1  = arr.slice(5)
// arr1  = arr.slice(2,8)
// arr1  = arr.slice(2,-2)
// arr1  = arr.slice(-7,7)
// console.log(`Array 1 : ${arr1}`)

// ------------------
// function
// ------------------

// bussiness logic 
// from ES 13 there are following type of functions

// 1) named function
// 2) anonymous function
// 3) rest parameter in function
// 4) default parameter  in function
// 5) optional parameter  in function
// --- adv.
// 6) generators
// 6) constructor
// 6) IIFE - (Immediate Invokable Function Expression)

// 1) named function
// the fuction with the particular name called as named function

// function defination
// function calling

// function defination
// ------------------------

// function fun-name(arg1,arg2,arg3,...,argn)
// {
    //  business logic
    //  return 
// }

// function calling
// ------------------
// fun-name(param1,param2,param3,...,paramn)

// console.log("1")
// function myFunc()
// {
//     console.log("2")
//     console.log("Hello, this is my Function..")
//     console.log("3")
// }
// console.log("4")
// myFunc()
// // myFunc()
// // myFunc()
// console.log("5")

// console.log("1")
// function myFunc()
// {
//     console.log("2")
//     return "Hello, this is my Function..";
//     // console.log("3")
// }
// console.log("3")
// console.log(myFunc())
// console.log("4")


// simple interest
// palindrom number
// total  1 to 10
// string reverse
// armstrong no. 