const bigInt = require('big-integer');
//Make sure to run npm install big-integer first

//Fix a prime
const prime = bigInt("3553741211");
const A = bigInt("1268349720") //I used a random number between 0 and prime, which will be coprime to prime.

//a function dlogProof(x, g, p) that returns (1) a residue y, evaluated as g^x (mod p) and 
//(2) a proof of knowledge pf that you know x that is the discrete log of y

function dlogProof(A,b,x) {
    const r = Math.floor(Math.random()*(prime-1));
    const h = bigInt(A).modPow(r,prime);
    const s = bigInt(bigInt(r).add(bigInt(b).multiply(x))).mod(prime.minus(1));
    console.log(s);
    return [h,s];
}

//a function verify(y, g, p, pf) that evaluates to true if pf is a valid proof of knowledge, 
//and false otherwise. The prover should only be able to compute a valid proof with non-negligible 
//probability if they do indeed know valid x

function verify(B,b,h,s) {
    const bigH = bigInt(h);
    const bigS = bigInt(s);
    return bigInt(A).modPow(bigS,prime).equals(bigH.multiply(bigInt(B).pow(b)).mod(prime));
}

function main() {
    const x = 123; // This is our secret identiy.
    const B = bigInt(A).modPow(x,prime); // Computes B=A^x mod prime
    console.log(`(A,B,p): (${A},${B},${prime})`);

    //Compute challenge bit
    const b = Math.random() > 0.5 ? 1: 0;
    
    let [h,s]=dlogProof(A,b,x);
    console.log("Verify: "+verify(B,b,h,s));
}

main();