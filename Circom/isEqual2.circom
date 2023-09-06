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


component main = isEqual();

/* INPUT = {
    "in": ["10","10"]
} */