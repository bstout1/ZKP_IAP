pragma circom 2.1.4;

template Num2Bits (nBits) {
    signal input in;

    signal output b[nBits];

    //Compute bit representation b based on "in" and make public ("in" is private)
    for(var i=0; i<nBits; i++) {
        b[i]<-- (in \ 2**i) % 2;
    }
    //Verify Correct representation
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

template Main() {
    signal input in;

    signal output out;

    component bitifier = Num2Bits(5);

    bitifier.in <== in;
    // b[1] is the second least significant bit of in
    out <== bitifier.b[1]+3;

}

component main = Main();

/* INPUT = {
    "in": "31"
} */