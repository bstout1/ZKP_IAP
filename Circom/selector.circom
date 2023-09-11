pragma circom 2.1.4;

template isZero() {
    signal input in;
    signal output out;
    signal inv;

    //Check if input signal is 0. Compute inverse if so.
    inv <-- in!=0 ? (1/in):0;

    //Compute and constain output signal. if in=0, then inv=0 and in*inv=0. Otherwise in*inv=1
    out <==1-in*inv; 

    //constain that either out is 0 or in is 0
    0 === in*out;
}

template isEqual() {
    signal input in[2];
    signal output out;

    //Use isZero template to check if in[0]-in[1] is zerp. Create a component and wire in and out. Constaint out to output wire.
    component isz = isZero();

    isz.in <-- in[0]-in[1];
    out <== isz.out;    
}

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template lessThan(n) {
    signal input in[2];
    signal output out;

    //out will be 1 if signal[0] < signal[1] and 0 otherwise;
    //we determine this by seing if signal[1] has more bits

    component n2b = Num2Bits(n+1);
    n2b.in <== in[0] + (1<<n) -in[1];
    out <== 1-n2b.out[n];
}

template Selector(nChoices) {
    signal input index;
    signal input in[nChoices];
    
    signal output out;

    //Range check index is between 0 and nChoices-1
    //If out of range, lessThan.out will be 0 and the contraint will cause 
    // compilation failure
    component lt = lessThan(4);
    lt.in[0] <== index;
    lt.in[1] <== nChoices;
    lt.out === 1;

    component equals[nChoices];
    signal equals_out[nChoices];
    signal sums[nChoices];
    
 
        //out <== in[nChoices];
        //use a for loop to find when the counter equals index
        //This is because numbers (like counters) can be wired as inputs to signals, 
        //but signals are not bumbers that can be accessed as indices to an array
        for (var i=0; i<nChoices; i++){
            equals[i]= isEqual();
            equals[i].in[0]<==i;
            equals[i].in[1]<==index;
            equals_out[i] <== equals[i].out * in[i];
        }
        // equals_out is now an array of nChoices signals. Each signal is 0 except for the
        // signal in index "index", which is equal to in[index]. We need to sum all these up
        // and then constrain it to the output signal
        sums[0]<==equals_out[0];
        for (var i=1; i< nChoices; i++) {
            sums[i] <== sums[i-1]+equals_out[i];
        }
        out <== sums[nChoices-1];

}

component main = Selector(5);

/* INPUT = {
    "index": "10",
    "in": ["0", "10", "20", "30", "40"]
} */