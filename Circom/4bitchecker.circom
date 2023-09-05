pragma circom 2.1.4;

template Num2Bits (nBits) {
    signal input in;

    signal input b[nBits];

    //Correct representation

    var accum = 0;
    for (var i=0; i<nBits; i++){
        accum+=(2**i)*b[i];
    }
    in === accum;

    //Need to verfiy b0,b1,b2,b3 are bits
    for (var i=0; i < nBits; i++){
        0 === b[i]*(b[i]-1);
    }

}

component main { public [b] } = Num2Bits(5);

/* INPUT = {
    "b":["1","1","1","1","1"],
    "in": "31"
} */