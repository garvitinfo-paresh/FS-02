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

